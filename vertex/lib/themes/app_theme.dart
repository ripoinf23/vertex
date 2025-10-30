import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان التطبيق الأساسية
class AppColors {
  // الألوان الرئيسية
  static const Color primary = Color(0xFF1A1F3A); // أزرق داكن
  static const Color secondary = Color(0xFFFF6B35); // برتقالي
  static const Color accent = Color(0xFFFFD700); // ذهبي
  
  // الخلفيات
  static const Color background = Color(0xFFF5F7FA); // رمادي فاتح جداً
  static const Color surface = Color(0xFFFFFFFF); // أبيض
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // النصوص
  static const Color textPrimary = Color(0xFF2D3748); // رمادي داكن
  static const Color textSecondary = Color(0xFF718096); // رمادي متوسط
  static const Color textLight = Color(0xFFA0AEC0); // رمادي فاتح
  static const Color textOnPrimary = Color(0xFFFFFFFF); // أبيض
  
  // الحالات
  static const Color success = Color(0xFF48BB78); // أخضر
  static const Color error = Color(0xFFF56565); // أحمر
  static const Color warning = Color(0xFFED8936); // برتقالي داكن
  static const Color info = Color(0xFF4299E1); // أزرق فاتح
  
  // الحدود والفواصل
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF2F7);
  
  // الأيقونات
  static const Color iconPrimary = Color(0xFF2D3748);
  static const Color iconSecondary = Color(0xFF718096);
  static const Color iconLight = Color(0xFFA0AEC0);
  
  // الظلال
  static const Color shadow = Color(0x1A000000);
  
  // الشفافية
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE2E8F0);
}

/// ألوان الوضع الليلي
class AppColorsDark {
  static const Color primary = Color(0xFF2D3748);
  static const Color secondary = Color(0xFFFF6B35);
  static const Color accent = Color(0xFFFFD700);
  
  static const Color background = Color(0xFF1A202C);
  static const Color surface = Color(0xFF2D3748);
  static const Color cardBackground = Color(0xFF2D3748);
  
  static const Color textPrimary = Color(0xFFF7FAFC);
  static const Color textSecondary = Color(0xFFE2E8F0);
  static const Color textLight = Color(0xFFA0AEC0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  static const Color success = Color(0xFF48BB78);
  static const Color error = Color(0xFFF56565);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF4299E1);
  
  static const Color border = Color(0xFF4A5568);
  static const Color divider = Color(0xFF2D3748);
  
  static const Color iconPrimary = Color(0xFFF7FAFC);
  static const Color iconSecondary = Color(0xFFE2E8F0);
  static const Color iconLight = Color(0xFFA0AEC0);
  
  static const Color shadow = Color(0x40000000);
  static const Color overlay = Color(0xA0000000);
  static const Color shimmer = Color(0xFF4A5568);
}

/// ثيم التطبيق (الوضع النهاري)
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // الألوان الأساسية
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.cardBackground,
    
    // نظام الألوان
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textOnPrimary,
    ),
    
    // الخطوط
    textTheme: GoogleFonts.interTextTheme().copyWith(
      // العناوين
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      
      // العناوين الفرعية
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      
      // النصوص الأساسية
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      
      // التسميات
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      ),
    ),
    
    // أنماط الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // أنماط البطاقات
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // أنماط حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.secondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textLight,
      ),
    ),
    
    // أنماط الأيقونات
    iconTheme: const IconThemeData(
      color: AppColors.iconPrimary,
      size: 24,
    ),
    
    // شريط التطبيق
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.iconPrimary,
      ),
    ),
    
    // شريط التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.iconSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    ),
    
    // الفواصل
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
  );
  
  /// ثيم الوضع الليلي
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    primaryColor: AppColorsDark.primary,
    scaffoldBackgroundColor: AppColorsDark.background,
    cardColor: AppColorsDark.cardBackground,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      secondary: AppColorsDark.secondary,
      tertiary: AppColorsDark.accent,
      surface: AppColorsDark.surface,
      error: AppColorsDark.error,
      onPrimary: AppColorsDark.textOnPrimary,
      onSecondary: AppColorsDark.textOnPrimary,
      onSurface: AppColorsDark.textPrimary,
      onError: AppColorsDark.textOnPrimary,
    ),
    
    // يمكن إضافة المزيد من التخصيصات للوضع الليلي هنا
    // (تم اختصارها لتوفير المساحة، لكن البنية مماثلة للوضع النهاري)
  );
}

/// مسافات وأبعاد ثابتة
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// أنصاف أقطار الحواف
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

/// الظلال
class AppShadows {
  static List<BoxShadow> small = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> large = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
