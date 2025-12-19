Tasky - Flutter Technical Task Solution

A high-performance Flutter application that manages a local task list using **Drift** (SQLite) with 10,000 tasks, smart search, filtering, sorting, and fully reactive UI updates.

Overview

This app fulfills all requirements of the provided technical task with a strong focus on performance, scalability, and smooth user experience even with a large dataset (10,000 tasks).

Key Features Implemented

- Local database using Drift with 10,000 pre-seeded tasks
- Smart keyword search across title & description
- Dynamic filtering by:
  - Task status (Completed / Incomplete)
  - Task type (Personal / Work)
- Sorting by creation date (Ascending / Descending)
- Infinite scrolling with pagination
- Fully reactive UI: any add/update/delete instantly reflects without manual refresh
- Add new tasks via bottom sheet
- Toggle task completion
- Optimized for performance on low-end devices

Technical Decisions & Performance Optimizations

1. Data Seeding (10,000 Tasks)
- Used AI assistance to conceptualize expanding data to 10,000 unique entries.
- Implemented smart seeding strategy in DataSeeder:
  - First 50 recent tasks inserted immediately → app becomes interactive instantly.
  - Remaining 9,950 tasks generated and inserted in background using:
    - compute() for isolate-based generation (no UI blocking)
    - Batched inserts (chunks of 500)
    - Small delays between chunks to keep UI responsive
- Prevents startup lag while ensuring full dataset is available shortly after launch.

2. Database Performance
- Created index on created_at for ultra-fast sorting.
- All queries use LIMIT for server-side pagination (never load all 10k tasks at once).
- Reactive streams via watch() ensure UI updates only when relevant data changes.

3. State Management & Reactivity
- Clean Architecture with:
  - Entity → Repository → UseCase → Cubit → UI
- TaskCubit (Bloc) manages state using rxdart for advanced stream handling.
- Full reactivity:
  - Any database change (add/edit/delete/toggle) triggers stream → Cubit → UI rebuild automatically.
  - No manual refresh needed.

4. Smart Search & Filtering
- Keyword search on title & description using Drift's contains.
- 300ms debounce on search input using BehaviorSubject.debounceTime() → prevents excessive queries during typing.
- Filters and sorting applied directly in SQL query → efficient and instant results.

5. Infinite Scroll & Lazy Loading
- Pagination with page size = 20.
- loadMoreTasks() increases SQL LIMIT dynamically.
- Loading indicator at bottom when more data available.
- hasReachedMax prevents unnecessary loads.

6. UI Performance
- Shimmer loading placeholders during initial seeding.
- cacheExtent: 200 on ListView for smooth scrolling.
- Scroll controller detects near-bottom to trigger load more.

7. Conflict Resolution
- All inserts/updates use insertOnConflictUpdate (UPSERT) → latest data always wins if concurrent modifications occur.

Project Structure Highlights
lib/
├── core/                   Styles, constants, utils, data_seeder
├── features/tasks/
│   ├── data/               Drift database, repository impl
│   ├── domain/             Entities, repository, usecases
│   ├── presentation/       Cubit, screens, widgets
├── injection_container.dart   Dependency injection (GetIt)
├── main.dart               App entry + seeding
└── app.dart                MaterialApp wrapper
