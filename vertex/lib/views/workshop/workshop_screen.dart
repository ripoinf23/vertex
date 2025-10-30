import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../services/fake_data_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/course_card.dart';

/// شاشة ورشة العمل (الدورات التعليمية)
class WorkshopScreen extends StatefulWidget {
  const WorkshopScreen({super.key});

  @override
  State<WorkshopScreen> createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  late List<Course> _courses;
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';

  final List<String> _categories = [
    'all',
    'sculpting',
    'lighting',
    'animation',
    'architecture',
  ];

  final Map<String, String> _categoryNames = {
    'all': 'الكل',
    'sculpting': 'النحت',
    'lighting': 'الإضاءة',
    'animation': 'الحركة',
    'architecture': 'المعمار',
  };

  final List<String> _difficulties = [
    'all',
    'beginner',
    'intermediate',
    'advanced',
  ];

  final Map<String, String> _difficultyNames = {
    'all': 'الكل',
    'beginner': 'مبتدئ',
    'intermediate': 'متوسط',
    'advanced': 'متقدم',
  };

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    _courses = FakeDataService.generateCourses(count: 20);
  }

  List<Course> get _filteredCourses {
    return _courses.where((course) {
      final categoryMatch = _selectedCategory == 'all' ||
          course.category == _selectedCategory;
      final difficultyMatch = _selectedDifficulty == 'all' ||
          course.difficultyLevel == _selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ورشة العمل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          // الفلاتر
          _buildFilters(),
          
          // قائمة الدورات
          Expanded(
            child: _buildCoursesList(),
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
          // الفئات
          Text(
            'الفئة',
            style: Theme.of(context).textTheme.labelLarge,
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
          
          const SizedBox(height: AppSpacing.md),
          
          // مستوى الصعوبة
          Text(
            'مستوى الصعوبة',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _difficulties.map((difficulty) {
                final isSelected = _selectedDifficulty == difficulty;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text(_difficultyNames[difficulty]!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = difficulty;
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

  Widget _buildCoursesList() {
    final filteredCourses = _filteredCourses;

    if (filteredCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.iconLight,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'لا توجد دورات مطابقة',
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

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CourseCard(
            course: course,
            onTap: () => _showCourseDetails(course),
          ),
        );
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _CourseSearchDelegate(_courses),
    );
  }

  void _showCourseDetails(Course course) {
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
              
              // عنوان الدورة
              Text(
                course.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // التقييم والمدة
              Row(
                children: [
                  const Icon(Icons.star, size: 20, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${course.averageRating.toStringAsFixed(1)} (${course.totalRatings})',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    course.durationText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // الوصف
              if (course.description != null) ...[
                Text(
                  'الوصف',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(course.description!),
                const SizedBox(height: AppSpacing.md),
              ],
              
              // ما ستتعلمه
              if (course.whatYouWillLearn != null &&
                  course.whatYouWillLearn!.isNotEmpty) ...[
                Text(
                  'ما ستتعلمه',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...course.whatYouWillLearn!.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                const SizedBox(height: AppSpacing.md),
              ],
              
              // المتطلبات
              if (course.requirements != null) ...[
                Text(
                  'المتطلبات',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(course.requirements!),
                const SizedBox(height: AppSpacing.md),
              ],
              
              // زر الاشتراك
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // الاشتراك في الدورة
                  },
                  child: Text(
                    course.isIncludedInPrime
                        ? 'ابدأ التعلم (مجاني لـ Prime)'
                        : 'اشترك الآن - \$${course.price.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseSearchDelegate extends SearchDelegate<Course?> {
  final List<Course> courses;

  _CourseSearchDelegate(this.courses);

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
    final results = courses.where((course) {
      return course.title.toLowerCase().contains(query.toLowerCase()) ||
          (course.description?.toLowerCase().contains(query.toLowerCase()) ??
              false);
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('لا توجد نتائج'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: CourseCard(
            course: results[index],
            onTap: () {
              close(context, results[index]);
            },
          ),
        );
      },
    );
  }
}
