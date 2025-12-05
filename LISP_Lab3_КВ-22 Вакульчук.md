<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 3</b><br/>
"Конструктивний і деструктивний підходи до роботи зі списками"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Вакульчук Ярослав Віталійович КВ-22</p>
<p align="right"><b>Рік</b>: 2025</p>

## Загальне завдання
Реалізуйте алгоритм сортування чисел у списку двома способами: функціонально і
імперативно.
1. Функціональний варіант реалізації має базуватись на використанні рекурсії і
конструюванні нових списків щоразу, коли необхідно виконати зміну вхідного
списку. Не допускається використання: псевдо-функцій, деструктивних операцій,
циклів . Також реалізована функція не має бути функціоналом

2. Імперативний варіант реалізації має базуватись на використанні циклів і
деструктивних функцій (псевдофункцій). Не допускається використання функцій
вищого порядку або функцій для роботи зі списками/послідовностями, що
використовуються як функції вищого порядку. Тим не менш, оригінальний список
цей варіант реалізації також не має змінювати, тому перед виконанням
деструктивних змін варто застосувати функцію copy-list (в разі необхідності).
Також реалізована функція не має бути функціоналом (тобто приймати на вхід
функції в якості аргументів).

Кожна реалізована функція має бути протестована для різних тестових наборів. Тести оформлюються у вигляді модульних тестів.

## Варіант 2
Алгоритм сортування обміном No1 (без оптимізацій) за незменшенням.

## Лістинг функції з використанням конструктивного підходу
```lisp
(defun func-bubble-sort (lst)
  (labels 
      ((bubble-pass (l)
         (cond
           ((null (cdr l)) l)
           ((> (car l) (cadr l))
            (cons (cadr l) 
                  (bubble-pass (cons (car l) (cddr l)))))
           (t 
            (cons (car l) 
                  (bubble-pass (cdr l))))))
       (sort-rec (l n)
         (if (zerop n)
             l
             (sort-rec (bubble-pass l) (1- n)))))
    (sort-rec lst (length lst))))
```

## Тестові набори та утиліти
```lisp
(defun check-test (name input expected actual)
  (if (equal expected actual)
      (format t "passed... ~18a Input: ~18a Result: ~a~%" name input actual)
      (format t "FAILED... ~18a Input: ~18a Expected: ~a Got: ~a~%" name input expected actual)))

(defun test-functional ()
  (format t "~%Testing Functional Bubble Sort~%")
  (check-test "Test 1 (Normal)"    '(3 1 4 1 5 9 2 6) '(1 1 2 3 4 5 6 9) (func-bubble-sort '(3 1 4 1 5 9 2 6)))
  (check-test "Test 2 (Sorted)"    '(1 2 3 4 5)       '(1 2 3 4 5)       (func-bubble-sort '(1 2 3 4 5)))
  (check-test "Test 3 (Reverse)"   '(5 4 3 2 1)       '(1 2 3 4 5)       (func-bubble-sort '(5 4 3 2 1)))
  (check-test "Test 4 (Negative)"  '(-3 0 2 -8)       '(-8 -3 0 2)       (func-bubble-sort '(-3 0 2 -8)))
  (check-test "Test 5 (Single)"    '(42)              '(42)              (func-bubble-sort '(42)))
  (check-test "Test 6 (Empty)"     '()                '()                (func-bubble-sort '())))
```

## Тестування
```lisp
Testing Functional Bubble Sort
passed... Test 1 (Normal)    Input: (3 1 4 1 5 9 2 6)  Result: (1 1 2 3 4 5 6 9)
passed... Test 2 (Sorted)    Input: (1 2 3 4 5)        Result: (1 2 3 4 5)
passed... Test 3 (Reverse)   Input: (5 4 3 2 1)        Result: (1 2 3 4 5)
passed... Test 4 (Negative)  Input: (-3 0 2 -8)        Result: (-8 -3 0 2)
passed... Test 5 (Single)    Input: (42)               Result: (42)
passed... Test 6 (Empty)     Input: NIL                Result: NIL
```

## Лістинг функції з використанням деструктивного підходу
```lisp
(defun imp-bubble-sort (lst)
  (let ((result (copy-list lst)))
    (do ((i 0 (1+ i))
         (n (length result))) 
        ((>= i (1- n)))
      (do ((curr result (cdr curr))) 
          ((null (cdr curr))) 
        (when (> (car curr) (cadr curr))
          (rotatef (car curr) (cadr curr)))))
    result))
```

## Тестові набори та утиліти
```lisp
(defun test-imperative ()
  (format t "~%Testing Imperative Bubble Sort~%")
  (check-test "Test 1 (Normal)"    '(3 1 4 1 5 9 2 6) '(1 1 2 3 4 5 6 9) (imp-bubble-sort '(3 1 4 1 5 9 2 6)))
  (check-test "Test 2 (Sorted)"    '(1 2 3 4 5)       '(1 2 3 4 5)       (imp-bubble-sort '(1 2 3 4 5)))
  (check-test "Test 3 (Reverse)"   '(5 4 3 2 1)       '(1 2 3 4 5)       (imp-bubble-sort '(5 4 3 2 1)))
  (check-test "Test 4 (Negative)"  '(-3 0 2 -8)       '(-8 -3 0 2)       (imp-bubble-sort '(-3 0 2 -8)))
  (check-test "Test 5 (Single)"    '(42)              '(42)              (imp-bubble-sort '(42)))
  (check-test "Test 6 (Empty)"     '()                '()                (imp-bubble-sort '())))
```

## Тестування
```lisp
Testing Imperative Bubble Sort
passed... Test 1 (Normal)    Input: (3 1 4 1 5 9 2 6)  Result: (1 1 2 3 4 5 6 9)
passed... Test 2 (Sorted)    Input: (1 2 3 4 5)        Result: (1 2 3 4 5)
passed... Test 3 (Reverse)   Input: (5 4 3 2 1)        Result: (1 2 3 4 5)
passed... Test 4 (Negative)  Input: (-3 0 2 -8)        Result: (-8 -3 0 2)
passed... Test 5 (Single)    Input: (42)               Result: (42)
passed... Test 6 (Empty)     Input: NIL                Result: NIL
```

