# Rick and Morty Character Browser

Мобильное приложение на Flutter для просмотра персонажей из мультсериала "Рик и Морти" с использованием [публичного API](https://rickandmortyapi.com/documentation/).

## Описание проекта

Rick and Morty Character Browser — это приложение, которое позволяет:
- Просматривать список всех персонажей с пагинацией
- Искать персонажей по имени, виду и статусу
- Добавлять персонажей в избранное
- Сортировать избранное по различным параметрам
- Работать в режиме офлайн благодаря локальному кешированию
- Переключаться между светлой и темной темами
- Просматривать подробную информацию о персонаже

## Функциональные возможности

### Главный экран (Список персонажей)
- Отображение персонажей в виде сетки (2 колонки) или списка
- Карточки содержат: изображение, имя, статус, вид, локацию
- Кнопка "сердечко" для добавления/удаления из избранного
- Бесконечная прокрутка с подгрузкой новых персонажей
- Поиск по имени, виду и статусу
- Pull-to-refresh для обновления данных
- Анимации появления карточек

### Экран "Избранное"
- Список избранных персонажей
- Сортировка по имени, статусу или виду
- Переключение порядка сортировки (по возрастанию/убыванию)
- Свайп для удаления из избранного с подтверждением
- Возможность отменить удаление (Undo)

### Экран деталей персонажа
- Подробная информация: имя, статус, вид, тип, пол
- Информация о происхождении и последней известной локации
- Hero-анимация изображения
- Кнопка добавления в избранное

### Дополнительно
- Офлайн-доступ к ранее загруженным данным
- Сохранение избранного в локальной базе данных
- Поддержка светлой и темной темы с возможностью переключения
- Сохранение настроек пользователя (режим отображения, тема)
- Кастомные анимации при добавлении/удалении избранных

## Архитектура

Проект построен на основе **Clean Architecture** с разделением на слои:

```
lib/
├── core/                   # Общая функциональность
│   ├── di/                # Dependency Injection (GetIt + Injectable)
│   ├── error/             # Обработка ошибок
│   ├── navigation/        # Навигация (GoRouter)
│   ├── network/           # HTTP клиент (Dio + Retrofit)
│   ├── presentation/      # Переиспользуемые UI виджеты
│   ├── services/          # Сервисы приложения
│   ├── theme/             # Темизация
│   └── utils/             # Константы
│
└── features/              # Функциональные модули
    ├── characters/        # Модуль персонажей
    │   ├── data/         # Источники данных, модели, репозитории
    │   ├── domain/       # Бизнес-логика, use cases, entities
    │   └── presentation/ # UI, BLoC
    │
    └── favorites/         # Модуль избранного
        └── presentation/  # UI, BLoC
```

### Используемые паттерны
- **BLoC** для управления состоянием
- **Repository Pattern** для абстракции доступа к данным
- **Use Case Pattern** для инкапсуляции бизнес-логики
- **Dependency Injection** с GetIt + Injectable
- **Either Pattern** (dartz) для обработки ошибок

## Технологический стек

### State Management
- `flutter_bloc: ^9.1.1` - Управление состоянием
- `hydrated_bloc: ^10.1.1` - Персистентное состояние

### Networking
- `dio: ^5.4.0` - HTTP клиент
- `retrofit: ^4.1.0` - REST API клиент

### Dependency Injection
- `get_it: ^9.1.1` - Service Locator
- `injectable: ^2.3.5` - Генерация DI кода

### Navigation
- `go_router: ^17.0.0` - Маршрутизация

### UI & Animations
- `cached_network_image: ^3.3.1` - Кеширование изображений
- `flutter_animate: ^4.5.0` - Анимации
- `flex_color_scheme: ^8.3.1` - Расширенная темизация

### Utilities
- `dartz: ^0.10.1` - Функциональное программирование (Either)
- `equatable: ^2.0.5` - Сравнение объектов
- `shared_preferences: ^2.2.2` - Локальное хранилище

### Code Generation
- `build_runner: ^2.4.8`
- `json_serializable: ^6.7.1`
- `injectable_generator: ^2.4.2`
- `retrofit_generator: ^10.2.0`

## Требования

- **Flutter SDK:** `>=3.10.0 <4.0.0`
- **Dart SDK:** `>=3.10.0 <4.0.0`

Проверенные версии:
- Flutter: **3.38.1** (stable)
- Dart: **3.10.0** (stable)

## Установка и запуск

### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd rick_and_morty
```

### 2. Установка зависимостей

```bash
flutter pub get
```

### 3. Генерация кода

Проект использует code generation для DI, JSON сериализации и Retrofit:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Для разработки с автоматической регенерацией:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Запуск приложения

```bash
flutter run
```

Или выберите устройство:

```bash
flutter devices
flutter run -d <device-id>
```

### 5. Сборка релизной версии

#### Android (APK)
```bash
flutter build apk --release
```

#### Android (App Bundle)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## Структура зависимостей

### Runtime Dependencies
```yaml
dependencies:
  flutter_bloc: ^9.1.1           # State management
  hydrated_bloc: ^10.1.1         # Persistent state
  dio: ^5.4.0                    # HTTP client
  retrofit: ^4.1.0               # REST API
  get_it: ^9.1.1                 # DI container
  injectable: ^2.3.5             # DI code generation
  go_router: ^17.0.0             # Navigation
  cached_network_image: ^3.3.1   # Image caching
  flutter_animate: ^4.5.0        # Animations
  flex_color_scheme: ^8.3.1      # Theming
  dartz: ^0.10.1                 # Functional programming
  equatable: ^2.0.5              # Value equality
  shared_preferences: ^2.2.2     # Local storage
  path_provider: ^2.1.2          # File paths
  json_annotation: ^4.8.1        # JSON serialization
```

### Development Dependencies
```yaml
dev_dependencies:
  build_runner: ^2.4.8           # Code generation
  json_serializable: ^6.7.1      # JSON serialization generator
  injectable_generator: ^2.4.2   # DI generator
  retrofit_generator: ^10.2.0    # Retrofit generator
  bloc_test: ^10.0.0             # BLoC testing
  mocktail: ^1.0.3               # Mocking
  very_good_analysis: ^10.0.0    # Linting
```

## Тестирование

Запуск unit и widget тестов:

```bash
flutter test
```

Запуск с покрытием кода:

```bash
flutter test --coverage
```

## Особенности реализации

### Кеширование и офлайн-режим
- **HydratedBloc** автоматически сохраняет состояние BLoC в локальное хранилище
- Загруженные персонажи сохраняются и доступны офлайн
- Избранное персистентно и синхронизируется между запусками

### Управление состоянием
- **CharactersBloc** - управляет списком персонажей, поиском, пагинацией
- **FavoritesBloc** - управляет избранными персонажами и сортировкой
- Синхронизация состояния между блоками через события

### Анимации
- Staggered анимации появления карточек
- Hero transitions для изображений
- Scale и shimmer эффекты при добавлении в избранное
- Плавные переходы между экранами

## API

Приложение использует [Rick and Morty API](https://rickandmortyapi.com/):
- **Base URL:** `https://rickandmortyapi.com/api`
- **Endpoints:**
  - `GET /character` - Список персонажей (с пагинацией)
  - `GET /character/{id}` - Детали персонажа

---

**Примечание:** Для корректной работы приложения требуется активное интернет-соединение при первом запуске для загрузки данных. После загрузки данные доступны в офлайн-режиме.
