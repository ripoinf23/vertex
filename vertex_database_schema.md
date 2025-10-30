# مخطط قاعدة البيانات - تطبيق Vertex

## نظرة عامة

قاعدة البيانات مصممة لتكون:
- **قابلة للتوسع (Scalable):** تدعم ملايين المستخدمين والمشاركات
- **آمنة (Secure):** حماية بيانات المستخدمين والمعاملات المالية
- **سريعة (Performant):** فهارس محسّنة لاستعلامات سريعة
- **مرنة (Flexible):** سهولة إضافة ميزات جديدة مستقبلاً

**نوع قاعدة البيانات:** PostgreSQL (عبر Amazon RDS)

---

## الجداول الرئيسية

### 1. جدول المستخدمين (Users)

هذا هو الجدول الأساسي الذي يحتوي على معلومات جميع المستخدمين.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500),
    location VARCHAR(100),
    website_url VARCHAR(500),
    
    -- نوع المستخدم
    user_type VARCHAR(20) DEFAULT 'user', -- 'user', 'designer', 'admin'
    
    -- حالة الاشتراك
    subscription_type VARCHAR(20) DEFAULT 'free', -- 'free', 'prime', 'pro'
    subscription_start_date TIMESTAMP,
    subscription_end_date TIMESTAMP,
    
    -- الإحصائيات
    total_wins INTEGER DEFAULT 0,
    total_submissions INTEGER DEFAULT 0,
    total_followers INTEGER DEFAULT 0,
    total_following INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    
    -- حالة الحساب
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    
    -- معلومات Stripe
    stripe_customer_id VARCHAR(100),
    stripe_account_id VARCHAR(100), -- للمصممين الذين يبيعون
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP
);

-- الفهارس لتسريع الاستعلامات
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription_type ON users(subscription_type);
CREATE INDEX idx_users_created_at ON users(created_at);
```

**الحقول المهمة:**
- `id`: معرف فريد لكل مستخدم (UUID للأمان)
- `subscription_type`: نوع الاشتراك (مجاني، Prime، Pro)
- `stripe_customer_id`: لربط المستخدم بحساب Stripe
- `stripe_account_id`: لربط المصمم بحساب Stripe Connect لاستقبال الأموال

---

### 2. جدول التحديات (Challenges)

يحتوي على جميع التحديات الأسبوعية (الماضية والحالية والمستقبلية).

```sql
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    challenge_number INTEGER UNIQUE NOT NULL, -- رقم التحدي (1, 2, 3, ...)
    title VARCHAR(200) NOT NULL,
    description TEXT,
    theme VARCHAR(100) NOT NULL, -- الموضوع (مثل: "روبوتات مساعدة")
    
    -- الصورة التوضيحية
    cover_image_url VARCHAR(500),
    
    -- التواريخ والحالة
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'active', 'voting', 'completed'
    submission_start_date TIMESTAMP NOT NULL,
    submission_end_date TIMESTAMP NOT NULL,
    voting_start_date TIMESTAMP NOT NULL,
    voting_end_date TIMESTAMP NOT NULL,
    
    -- الإحصائيات
    total_submissions INTEGER DEFAULT 0,
    total_votes INTEGER DEFAULT 0,
    total_views INTEGER DEFAULT 0,
    
    -- الفائزون (يتم تحديثها بعد انتهاء التصويت)
    first_place_user_id UUID REFERENCES users(id),
    second_place_user_id UUID REFERENCES users(id),
    third_place_user_id UUID REFERENCES users(id),
    
    -- معلومات إضافية
    rules TEXT, -- قواعد التحدي
    prizes TEXT, -- الجوائز (إن وجدت)
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id) -- المدير الذي أنشأ التحدي
);

-- الفهارس
CREATE INDEX idx_challenges_status ON challenges(status);
CREATE INDEX idx_challenges_submission_dates ON challenges(submission_start_date, submission_end_date);
CREATE INDEX idx_challenges_challenge_number ON challenges(challenge_number);
```

**الحقول المهمة:**
- `status`: حالة التحدي (مجدول، نشط، تصويت، مكتمل)
- `submission_start_date` و `submission_end_date`: فترة استقبال المشاركات
- `voting_start_date` و `voting_end_date`: فترة التصويت
- `first/second/third_place_user_id`: الفائزون الثلاثة

---

### 3. جدول المشاركات (Submissions)

يحتوي على جميع التصاميم التي شارك بها المستخدمون في التحديات.

```sql
CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- محتوى المشاركة
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- الملفات
    main_image_url VARCHAR(500) NOT NULL, -- الصورة الرئيسية
    additional_images_urls TEXT[], -- صور إضافية (مصفوفة)
    video_url VARCHAR(500), -- فيديو دوران 360 (اختياري)
    
    -- الإحصائيات
    total_votes INTEGER DEFAULT 0,
    total_comments INTEGER DEFAULT 0,
    total_views INTEGER DEFAULT 0,
    
    -- الترتيب والجوائز
    rank INTEGER, -- الترتيب النهائي (يتم تحديثه بعد انتهاء التصويت)
    is_winner BOOLEAN DEFAULT FALSE,
    prize_position INTEGER, -- 1, 2, أو 3 إذا كان فائزاً
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'flagged'
    moderation_notes TEXT, -- ملاحظات الإشراف
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_submissions_challenge_id ON submissions(challenge_id);
CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_total_votes ON submissions(total_votes DESC);
CREATE INDEX idx_submissions_created_at ON submissions(created_at);
CREATE UNIQUE INDEX idx_submissions_user_challenge ON submissions(user_id, challenge_id); -- مستخدم واحد = مشاركة واحدة لكل تحدي
```

**الحقول المهمة:**
- `additional_images_urls`: مصفوفة من الروابط للصور الإضافية
- `rank`: الترتيب النهائي بعد التصويت
- `status`: حالة المشاركة (معلق، موافق عليه، مرفوض، مبلّغ عنه)

---

### 4. جدول الأصوات (Votes)

يسجل كل صوت يدلي به المستخدمون على المشاركات.

```sql
CREATE TABLE votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع التصويت
    vote_type VARCHAR(20) DEFAULT 'like', -- 'like', 'dislike' (حالياً نستخدم like فقط)
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_votes_submission_id ON votes(submission_id);
CREATE INDEX idx_votes_user_id ON votes(user_id);
CREATE UNIQUE INDEX idx_votes_user_submission ON votes(user_id, submission_id); -- مستخدم واحد = صوت واحد لكل مشاركة
```

**ملاحظة:** القيد الفريد `idx_votes_user_submission` يضمن أن المستخدم لا يمكنه التصويت أكثر من مرة على نفس المشاركة.

---

### 5. جدول الأصول الرقمية (Assets)

يحتوي على جميع الأصول الرقمية المعروضة للبيع في المتجر.

```sql
CREATE TABLE assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- المصمم البائع
    
    -- معلومات الأصل
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50), -- 'model', 'material', 'source_file', 'texture'
    
    -- الملفات
    preview_image_url VARCHAR(500) NOT NULL,
    additional_images_urls TEXT[],
    
    -- ملفات التحميل (مشفرة/محمية)
    download_files JSONB, -- [{name: 'file.stl', url: 's3://...', size: '5MB'}]
    
    -- السعر
    price DECIMAL(10,2) NOT NULL, -- بالدولار
    currency VARCHAR(3) DEFAULT 'USD',
    
    -- الإحصائيات
    total_downloads INTEGER DEFAULT 0,
    total_sales INTEGER DEFAULT 0,
    total_revenue DECIMAL(10,2) DEFAULT 0.0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    total_ratings INTEGER DEFAULT 0,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'inactive', 'under_review'
    is_featured BOOLEAN DEFAULT FALSE,
    
    -- معلومات إضافية
    tags TEXT[], -- ['robot', 'sci-fi', 'mechanical']
    file_formats TEXT[], -- ['STL', 'OBJ', 'FBX']
    polygon_count INTEGER,
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_assets_user_id ON assets(user_id);
CREATE INDEX idx_assets_category ON assets(category);
CREATE INDEX idx_assets_price ON assets(price);
CREATE INDEX idx_assets_total_sales ON assets(total_sales DESC);
CREATE INDEX idx_assets_created_at ON assets(created_at DESC);
```

**الحقول المهمة:**
- `download_files`: JSONB يحتوي على معلومات الملفات القابلة للتحميل
- `tags`: مصفوفة من الوسوم لتسهيل البحث
- `is_featured`: لإبراز أصول مميزة في الصفحة الرئيسية

---

### 6. جدول الدورات التعليمية (Courses)

يحتوي على جميع ورش العمل والدورات التعليمية.

```sql
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- المصمم المعلم
    submission_id UUID REFERENCES submissions(id), -- المشاركة الفائزة المرتبطة (إن وجدت)
    
    -- معلومات الدورة
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50), -- 'sculpting', 'lighting', 'animation', 'architecture'
    difficulty_level VARCHAR(20), -- 'beginner', 'intermediate', 'advanced'
    
    -- الملفات
    cover_image_url VARCHAR(500) NOT NULL,
    trailer_video_url VARCHAR(500), -- فيديو ترويجي مجاني
    
    -- محتوى الدورة (الفيديوهات)
    lessons JSONB, -- [{title: 'Lesson 1', duration: '10:30', video_url: '...', is_free: true}]
    total_duration INTEGER, -- بالدقائق
    total_lessons INTEGER,
    
    -- السعر
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    is_included_in_prime BOOLEAN DEFAULT TRUE, -- متاحة لمشتركي Prime؟
    
    -- الإحصائيات
    total_enrollments INTEGER DEFAULT 0,
    total_sales INTEGER DEFAULT 0,
    total_revenue DECIMAL(10,2) DEFAULT 0.0,
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    total_ratings INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,2) DEFAULT 0.0, -- نسبة المستخدمين الذين أكملوا الدورة
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'inactive', 'under_review'
    is_featured BOOLEAN DEFAULT FALSE,
    
    -- معلومات إضافية
    tags TEXT[],
    requirements TEXT, -- المتطلبات المسبقة
    what_you_will_learn TEXT[], -- ماذا ستتعلم
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_courses_user_id ON courses(user_id);
CREATE INDEX idx_courses_category ON courses(category);
CREATE INDEX idx_courses_price ON courses(price);
CREATE INDEX idx_courses_total_sales ON courses(total_sales DESC);
CREATE INDEX idx_courses_average_rating ON courses(average_rating DESC);
```

**الحقول المهمة:**
- `lessons`: JSONB يحتوي على قائمة الدروس بتفاصيلها
- `is_included_in_prime`: هل الدورة متاحة لمشتركي Prime؟
- `submission_id`: ربط الدورة بالمشاركة الفائزة التي تشرحها

---

### 7. جدول الاشتراكات (Subscriptions)

يسجل جميع الاشتراكات (Prime و Pro).

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع الاشتراك
    subscription_type VARCHAR(20) NOT NULL, -- 'prime', 'pro'
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'cancelled', 'expired', 'past_due'
    
    -- التواريخ
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    cancelled_at TIMESTAMP,
    
    -- معلومات الدفع
    stripe_subscription_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    billing_cycle VARCHAR(20) DEFAULT 'monthly', -- 'monthly', 'yearly'
    
    -- معلومات إضافية
    trial_end_date TIMESTAMP, -- نهاية الفترة التجريبية
    is_trial BOOLEAN DEFAULT FALSE,
    auto_renew BOOLEAN DEFAULT TRUE,
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_end_date ON subscriptions(end_date);
CREATE INDEX idx_subscriptions_stripe_subscription_id ON subscriptions(stripe_subscription_id);
```

**الحقول المهمة:**
- `stripe_subscription_id`: معرف الاشتراك في Stripe
- `auto_renew`: هل سيتم التجديد التلقائي؟
- `is_trial`: هل هذا اشتراك تجريبي؟

---

### 8. جدول المشتريات (Purchases)

يسجل جميع عمليات الشراء (أصول رقمية ودورات).

```sql
CREATE TABLE purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع المشتريات
    purchase_type VARCHAR(20) NOT NULL, -- 'asset', 'course'
    asset_id UUID REFERENCES assets(id),
    course_id UUID REFERENCES courses(id),
    
    -- معلومات الدفع
    stripe_payment_intent_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    
    -- توزيع الأرباح
    platform_fee DECIMAL(10,2), -- حصة المنصة (30%)
    seller_amount DECIMAL(10,2), -- حصة البائع (70%)
    seller_user_id UUID REFERENCES users(id), -- البائع
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'completed', -- 'pending', 'completed', 'refunded', 'failed'
    
    -- معلومات إضافية
    refund_reason TEXT,
    refunded_at TIMESTAMP,
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_purchases_user_id ON purchases(user_id);
CREATE INDEX idx_purchases_seller_user_id ON purchases(seller_user_id);
CREATE INDEX idx_purchases_purchase_type ON purchases(purchase_type);
CREATE INDEX idx_purchases_status ON purchases(status);
CREATE INDEX idx_purchases_created_at ON purchases(created_at DESC);

-- قيد للتأكد من أن المشتريات تشير إلى أصل أو دورة (وليس كليهما)
ALTER TABLE purchases ADD CONSTRAINT check_purchase_type 
    CHECK (
        (purchase_type = 'asset' AND asset_id IS NOT NULL AND course_id IS NULL) OR
        (purchase_type = 'course' AND course_id IS NOT NULL AND asset_id IS NULL)
    );
```

**الحقول المهمة:**
- `platform_fee` و `seller_amount`: توزيع الأرباح بين المنصة والبائع
- `stripe_payment_intent_id`: معرف عملية الدفع في Stripe
- القيد `check_purchase_type`: يضمن أن كل عملية شراء تشير إلى أصل أو دورة فقط

---

### 9. جدول التعليقات (Comments)

يحتوي على جميع التعليقات على المشاركات والدورات والأصول.

```sql
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع التعليق
    comment_type VARCHAR(20) NOT NULL, -- 'submission', 'course', 'asset'
    submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    asset_id UUID REFERENCES assets(id) ON DELETE CASCADE,
    
    -- محتوى التعليق
    content TEXT NOT NULL,
    
    -- التعليقات المتداخلة (الردود)
    parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    
    -- الإحصائيات
    total_likes INTEGER DEFAULT 0,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'deleted', 'flagged'
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_submission_id ON comments(submission_id);
CREATE INDEX idx_comments_course_id ON comments(course_id);
CREATE INDEX idx_comments_asset_id ON comments(asset_id);
CREATE INDEX idx_comments_parent_comment_id ON comments(parent_comment_id);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);
```

**الحقول المهمة:**
- `parent_comment_id`: للسماح بالردود على التعليقات (تعليقات متداخلة)
- `comment_type`: نوع الكائن الذي تم التعليق عليه

---

### 10. جدول الإشعارات (Notifications)

يحتوي على جميع الإشعارات المرسلة للمستخدمين.

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع الإشعار
    notification_type VARCHAR(50) NOT NULL, -- 'challenge_win', 'new_comment', 'new_follower', 'purchase', 'vote'
    
    -- محتوى الإشعار
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    
    -- الرابط المرتبط
    action_url VARCHAR(500), -- الرابط الذي سينتقل إليه المستخدم عند النقر
    
    -- معلومات إضافية (JSON مرن)
    metadata JSONB, -- {challenge_id: '...', submission_id: '...'}
    
    -- الحالة
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
```

**الحقول المهمة:**
- `notification_type`: نوع الإشعار لتحديد الأيقونة والأولوية
- `metadata`: بيانات إضافية مرنة بصيغة JSON
- `action_url`: الرابط الذي سينتقل إليه المستخدم

---

### 11. جدول المتابعة (Follows)

يسجل علاقات المتابعة بين المستخدمين.

```sql
CREATE TABLE follows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- المتابِع
    following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- المتابَع
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_follows_follower_id ON follows(follower_id);
CREATE INDEX idx_follows_following_id ON follows(following_id);
CREATE UNIQUE INDEX idx_follows_unique ON follows(follower_id, following_id); -- لا يمكن متابعة نفس الشخص مرتين
```

---

### 12. جدول التقييمات (Ratings)

يسجل تقييمات المستخدمين للدورات والأصول.

```sql
CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع التقييم
    rating_type VARCHAR(20) NOT NULL, -- 'course', 'asset'
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    asset_id UUID REFERENCES assets(id) ON DELETE CASCADE,
    
    -- التقييم
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5), -- من 1 إلى 5 نجوم
    review TEXT, -- مراجعة نصية (اختياري)
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_ratings_user_id ON ratings(user_id);
CREATE INDEX idx_ratings_course_id ON ratings(course_id);
CREATE INDEX idx_ratings_asset_id ON ratings(asset_id);
CREATE UNIQUE INDEX idx_ratings_user_course ON ratings(user_id, course_id); -- تقييم واحد لكل دورة
CREATE UNIQUE INDEX idx_ratings_user_asset ON ratings(user_id, asset_id); -- تقييم واحد لكل أصل
```

---

### 13. جدول البلاغات (Reports)

يسجل البلاغات عن المحتوى المخالف.

```sql
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- نوع المحتوى المبلّغ عنه
    report_type VARCHAR(20) NOT NULL, -- 'submission', 'comment', 'user'
    submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE,
    comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    reported_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    
    -- سبب البلاغ
    reason VARCHAR(50) NOT NULL, -- 'inappropriate', 'spam', 'offensive', 'copyright'
    description TEXT,
    
    -- الحالة
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'reviewed', 'action_taken', 'dismissed'
    admin_notes TEXT,
    reviewed_by UUID REFERENCES users(id),
    reviewed_at TIMESTAMP,
    
    -- التواريخ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الفهارس
CREATE INDEX idx_reports_reporter_user_id ON reports(reporter_user_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);
```

---

## العلاقات بين الجداول (Relationships)

### علاقات رئيسية:

1. **User → Submissions** (واحد لمتعدد)
   - مستخدم واحد يمكنه إنشاء عدة مشاركات

2. **Challenge → Submissions** (واحد لمتعدد)
   - تحدي واحد يحتوي على عدة مشاركات

3. **Submission → Votes** (واحد لمتعدد)
   - مشاركة واحدة يمكن أن تحصل على عدة أصوات

4. **User → Courses** (واحد لمتعدد)
   - مصمم واحد يمكنه إنشاء عدة دورات

5. **User → Assets** (واحد لمتعدد)
   - مصمم واحد يمكنه بيع عدة أصول

6. **User → Purchases** (واحد لمتعدد)
   - مستخدم واحد يمكنه شراء عدة أصول/دورات

7. **User → Subscriptions** (واحد لمتعدد)
   - مستخدم واحد يمكن أن يكون له عدة اشتراكات (تاريخية)

8. **User → Follows** (متعدد لمتعدد)
   - مستخدم يمكنه متابعة عدة مستخدمين، ويمكن أن يتابعه عدة مستخدمين

---

## الاستعلامات الشائعة المحسّنة

### 1. الحصول على التحدي النشط الحالي مع عدد المشاركات:

```sql
SELECT c.*, COUNT(s.id) as submission_count
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
WHERE c.status = 'active'
GROUP BY c.id
LIMIT 1;
```

### 2. الحصول على أفضل 10 مشاركات في تحدي معين (حسب الأصوات):

```sql
SELECT s.*, u.username, u.avatar_url, COUNT(v.id) as vote_count
FROM submissions s
JOIN users u ON s.user_id = u.id
LEFT JOIN votes v ON s.id = v.submission_id
WHERE s.challenge_id = 'challenge_uuid_here'
GROUP BY s.id, u.id
ORDER BY vote_count DESC
LIMIT 10;
```

### 3. الحصول على ملف المصمم الشخصي مع إحصائياته:

```sql
SELECT 
    u.*,
    COUNT(DISTINCT s.id) as total_submissions,
    COUNT(DISTINCT CASE WHEN s.is_winner = TRUE THEN s.id END) as total_wins,
    COUNT(DISTINCT f.id) as follower_count,
    AVG(r.rating) as average_rating
FROM users u
LEFT JOIN submissions s ON u.id = s.user_id
LEFT JOIN follows f ON u.id = f.following_id
LEFT JOIN ratings r ON u.id = r.user_id
WHERE u.id = 'user_uuid_here'
GROUP BY u.id;
```

### 4. الحصول على الدورات المتاحة لمشترك Prime:

```sql
SELECT c.*, u.username as instructor_name
FROM courses c
JOIN users u ON c.user_id = u.id
WHERE c.is_included_in_prime = TRUE
  AND c.status = 'active'
ORDER BY c.average_rating DESC, c.total_enrollments DESC;
```

---

## الأمان والصلاحيات

### مستويات الوصول:

1. **المستخدم العادي (User):**
   - قراءة: جميع المحتوى العام
   - كتابة: المشاركات، التعليقات، الأصوات
   - لا يمكنه: تعديل محتوى الآخرين، الوصول لبيانات الدفع

2. **المصمم (Designer):**
   - كل صلاحيات المستخدم العادي
   - إضافة: دورات وأصول رقمية للبيع
   - الوصول: إحصائيات مبيعاته وأرباحه

3. **المدير (Admin):**
   - الوصول الكامل لجميع الجداول
   - إدارة: التحديات، مراجعة البلاغات، حظر المستخدمين

### حماية البيانات الحساسة:

- **كلمات المرور:** مشفرة باستخدام bcrypt (لا تُخزن أبداً بشكل نصي)
- **معلومات الدفع:** لا تُخزن أبداً في قاعدة بياناتنا، فقط معرفات Stripe
- **الملفات القابلة للتحميل:** محمية برابط موقّع (Signed URL) من S3

---

## النسخ الاحتياطي والاستعادة

### استراتيجية النسخ الاحتياطي:

1. **نسخ احتياطي تلقائي يومي** عبر Amazon RDS
2. **نسخ احتياطي يدوي** قبل أي تحديث رئيسي
3. **الاحتفاظ بالنسخ** لمدة 30 يوماً
4. **Point-in-Time Recovery:** استعادة قاعدة البيانات لأي دقيقة خلال آخر 7 أيام

---

## التوسع المستقبلي

### ميزات يمكن إضافتها لاحقاً:

1. **جدول الرسائل الخاصة (Direct Messages)**
2. **جدول المجموعات/الفرق (Teams)**
3. **جدول الشارات والإنجازات (Badges & Achievements)**
4. **جدول الأحداث المباشرة (Live Events)**
5. **جدول الترجمات (Translations)** لدعم لغات متعددة

---

## الخلاصة

هذا المخطط يوفر:
- ✅ **هيكل قوي ومرن** يدعم جميع ميزات التطبيق الحالية
- ✅ **أمان عالي** لحماية بيانات المستخدمين والمعاملات المالية
- ✅ **أداء محسّن** مع فهارس مدروسة لأكثر الاستعلامات شيوعاً
- ✅ **قابلية للتوسع** لإضافة ميزات جديدة دون إعادة هيكلة كبيرة

**الحالة:** جاهز للمراجعة والموافقة  
**التاريخ:** 28 أكتوبر 2025  
**الإصدار:** 1.0
