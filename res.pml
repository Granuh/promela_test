// Все на левом берегу
bit boat = 0;
bit wolf = 0;
bit goat = 0;
bit cabb = 0;

#define UNSAFE ((wolf == goat) && (wolf != boat) || (goat == cabb) && (goat != boat))
#define SAFE !(UNSAFE)

active proctype main() {
  do
  :: (wolf != goat) && (goat != cabb)->
      atomic {
          printf("Action: Move boat only\n"); // Добавленный вывод
          printf("Before: boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод до
          printf("boat\n");
          boat = 1 - boat;
          printf("After:  boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод после
          printf("---\n"); // Разделитель для удобства чтения
      }
  :: (wolf == boat) && (goat != cabb) ->
      atomic {
          printf("Action: Move wolf\n"); // Добавленный вывод
          printf("Before: boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод до
          printf("wolf\n");
          boat = 1 - boat;
          wolf = boat;
          printf("After:  boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод после
          printf("---\n"); // Разделитель
      }
  :: (goat == boat) ->
      atomic {
          printf("Action: Move goat\n"); // Добавленный вывод
          printf("Before: boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод до
          printf("goat\n");
          boat = 1 - boat;
          goat = boat;
          printf("After:  boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод после
          printf("---\n"); // Разделитель
      }
  :: (cabb == boat) && (wolf != goat) ->
      atomic {
          printf("Action: Move cabbage\n"); // Добавленный вывод
          printf("Before: boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод до
          printf("cabb\n");
          boat = 1 - boat;
          cabb = boat;
          printf("After:  boat=%d, wolf=%d, goat=%d, cabb=%d\n", boat, wolf, goat, cabb); // Вывод после
          printf("---\n"); // Разделитель
      }
  od
}

ltl GoalNeverReached {
    !(<> (boat && wolf && goat && cabb))
}