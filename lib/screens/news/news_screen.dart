import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sotkonya/providers/riverpod_providers.dart';

import 'package:sotkonya/l10n/app_localizations.dart';

import 'package:sotkonya/widgets/layouts/base_page_layout.dart';
import 'package:sotkonya/widgets/shimmer_widgets.dart';
import 'package:sotkonya/screens/news/widgets/news_item_card.dart';
import 'package:sotkonya/screens/news/add_news_screen.dart';
import 'package:sotkonya/screens/news/edit_news_screen.dart';
import 'package:sotkonya/screens/news/widgets/news_details_screen.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(newsProvider);
      if (state.news.isEmpty && !state.loading) {
        ref.read(newsProvider).fetchNews();
      }
    });
  }

  void _showAdminActions(BuildContext context, dynamic item) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text(l10n.editNews),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditNewsScreen(news: item),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(l10n.deleteNews, style: const TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.deleteNews),
                    content: Text(l10n.deleteConfirmMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(newsProvider).deleteNews(item.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsProvider);
    final auth = ref.watch(authProvider);
    final isAdmin = auth.isAdmin;

    final l10n = AppLocalizations.of(context)!;

    return BasePageLayout(
      title: l10n.news,
      child: state.loading
          ? const ShimmerNewsList()
          : Column(
              children: [
                if (isAdmin)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006db7),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddNewsScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                       label: Text(
                        l10n.addNews,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (state.news.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        l10n.noNewsYet,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: state.news.length,
                    shrinkWrap: true,
                    separatorBuilder: (_, _) => const SizedBox(height: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = state.news[index];
                      return GestureDetector(
                        onLongPress: isAdmin ? () => _showAdminActions(context, item) : null,
                        child: NewsItemCard(
                          obj: item,
                          iconData: Icons.article,
                          color: const Color(0xFF006db7),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewsDetailsScreen(
                                  color: const Color(0xFF006db7),
                                  obj: item,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}





