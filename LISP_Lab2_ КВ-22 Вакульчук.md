<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Вакульчук Ярослав Віталійович КВ-22</p>
<p align="right"><b>Рік</b>: 2025</p>

## Загальне завдання
Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами).
Вимоги до функцій:
1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового
списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій
для роботи зі списками, що не наведені в четвертому розділі навчального
посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції
в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.
Кожна реалізована функція має бути протестована для різних тестових наборів.

## Варіант 2
<p align="center">
<img src="lab2_1.png">
</p>

## Лістинг функції remove-seconds-and-thirds
```lisp
(defun remove-seconds-and-thirds (lst)
  (cond
    ((null lst) nil)
    (t (cons (car lst) 
             (remove-seconds-and-thirds (cdddr lst))))))
```
### Тестові набори та утиліти
```lisp
(defun check-result (name actual expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal actual expected)
          name))

(defun test-remove-seconds-and-thirds ()
  (format t "~%Testing remove-seconds-and-thirds~%")
  (check-result "Test 1: Example (a b c d e f g)" (remove-seconds-and-thirds '(a b c d e f g)) '(A D G))
  (check-result "Test 2: Short list (1 2)" (remove-seconds-and-thirds '(1 2)) '(1))
  (check-result "Test 3: Empty list" (remove-seconds-and-thirds '()) nil))
```
## Лістинг функції list-set-intersection
```lisp
(defun is-in-list (elem lst)
  (cond
    ((null lst) nil)
    ((equal (car lst) elem) t)
    (t (is-in-list elem (cdr lst)))))

(defun list-set-intersection (set1 set2)
  (cond
    ((null set1) nil)
    ((is-in-list (car set1) set2) 
     (cons (car set1) 
           (list-set-intersection (cdr set1) set2)))
    (t (list-set-intersection (cdr set1) set2))))
```
### Тестові набори та утиліти
```lisp
(defun test-list-set-intersection ()
  (format t "~%Testing list-set-intersection~%")
  (check-result "Test 1: Example (1 2 3 4) (3 4 5 6)" (list-set-intersection '(1 2 3 4) '(3 4 5 6)) '(3 4))
  (check-result "Test 2: No intersection" (list-set-intersection '(a b) '(c d)) nil)
  (check-result "Test 3: Empty set" (list-set-intersection '() '(1 2 3)) nil))
```
### Тестування
```lisp
(test-remove-seconds-and-thirds)
(test-list-set-intersection)

Testing remove-seconds-and-thirds
passed... Test 1: Example (a b c d e f g)
passed... Test 2: Short list (1 2)
passed... Test 3: Empty list

Testing list-set-intersection
passed... Test 1: Example (1 2 3 4) (3 4 5 6)
passed... Test 2: No intersection
passed... Test 3: Empty set
NIL
```


