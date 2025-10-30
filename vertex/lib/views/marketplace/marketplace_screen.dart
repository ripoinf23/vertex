import 'package:flutter/material.dart';
import '../../models/asset.dart';
import '../../services/fake_data_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/asset_card.dart';

/// شاشة المتجر (الأصول الرقمية)
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late List<Asset> _assets;
  String _selectedCategory = 'all';
  String _sortBy = 'popular'; // 'popular', 'newest', 'price_low', 'price_high'

  final List<String> _categories = [
    'all',
    'model',
    'material',
    'source_file',
    'texture',
  ];

  final Map<String, String> _categoryNames = {
    'all': 'الكل',
    'model': 'نماذج',
    'material': 'مواد',
    'source_file': 'ملفات مصدر',
    'texture': 'نسيج',
  };

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  void _loadAssets() {
    _assets = FakeDataService.generateAssets(count: 30);
  }

  List<Asset> get _filteredAndSortedAssets {
    var filtered = _assets.where((asset) {
      return _selectedCategory == 'all' ||
          asset.category == _selectedCategory;
    }).toList();

    // الترتيب
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popular':
      default:
        filtered.sort((a, b) => b.totalSales.compareTo(a.totalSales));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // الفلاتر
          _buildFilters(),
          
          // شبكة الأصول
          Expanded(
            child: _buildAssetsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'الفئة',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Text(
                _getSortLabel(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(_categoryNames[category]!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.secondary.withOpacity(0.2),
                    checkmarkColor: AppColors.secondary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsGrid() {
    final filteredAssets = _filteredAndSortedAssets;

    if (filteredAssets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: AppColors.iconLight,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'لا توجد أصول مطابقة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'جرب تغيير الفلاتر',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        final asset = filteredAssets[index];
        return AssetCard(
          asset: asset,
          onTap: () => _showAssetDetails(asset),
        );
      },
    );
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'newest':
        return 'الأحدث';
      case 'price_low':
        return 'السعر: من الأقل';
      case 'price_high':
        return 'السعر: من الأعلى';
      case 'popular':
      default:
        return 'الأكثر مبيعاً';
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ترتيب حسب',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildSortOption('الأكثر مبيعاً', 'popular'),
            _buildSortOption('الأحدث', 'newest'),
            _buildSortOption('السعر: من الأقل', 'price_low'),
            _buildSortOption('السعر: من الأعلى', 'price_high'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.secondary)
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _AssetSearchDelegate(_assets),
    );
  }

  void _showAssetDetails(Asset asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            controller: scrollController,
            children: [
              // مقبض السحب
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              
              // عنوان الأصل
              Text(
                asset.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // السعر والتقييم
              Row(
                children: [
                  Text(
                    '\$${asset.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, size: 20, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${asset.averageRating.toStringAsFixed(1)} (${asset.totalRatings})',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // الإحصائيات
              Row(
                children: [
                  _buildStatChip(
                    icon: Icons.download,
                    label: '${asset.totalDownloads} تحميل',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildStatChip(
                    icon: Icons.shopping_cart,
                    label: '${asset.totalSales} مبيعات',
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // الوصف
              if (asset.description != null) ...[
                Text(
                  'الوصف',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(asset.description!),
                const SizedBox(height: AppSpacing.md),
              ],
              
              // التفاصيل التقنية
              Text(
                'التفاصيل التقنية',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildDetailRow('الفئة', asset.categoryArabic),
              _buildDetailRow('صيغ الملفات', asset.fileFormatsText),
              if (asset.polygonCount != null)
                _buildDetailRow('عدد المضلعات', asset.polygonCountText),
              
              const SizedBox(height: AppSpacing.lg),
              
              // زر الشراء
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // الشراء
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: Text('شراء الآن - \$${asset.price.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetSearchDelegate extends SearchDelegate<Asset?> {
  final List<Asset> assets;

  _AssetSearchDelegate(this.assets);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = assets.where((asset) {
      return asset.title.toLowerCase().contains(query.toLowerCase()) ||
          (asset.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('لا توجد نتائج'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return AssetCard(
          asset: results[index],
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
