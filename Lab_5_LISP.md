<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 5</b><br/>
"Робота з базою даних"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Вакульчук Ярослав Віталійович КВ-22</p>
<p align="right"><b>Рік</b>: 2025</p>

## Загальне завдання
В роботі необхідно реалізувати утиліти для роботи з базою даних. База даних складається з кількох таблиць. Таблиці представлені у вигляді CSV
файлів. При зчитуванні записів з таблиць, кожен запис має бути представлений певним
типом в залежності від варіанту
1. Визначити структури та/або утиліти для створення записів з таблиць
2. Розробити утиліту(-и) для зчитування таблиць з файлів. Значення колонок мають
бути розібрані відповідно до типу даних у них. 
3. Розробити функцію select , яка отримує на вхід шлях до файлу з таблицею, а
також якийсь об'єкт, який дасть змогу зчитати записи конкретного типу або
структури. Це може бути ключ, список з якоюсь допоміжною інформацією, функція і
т. і. За потреби параметрів може бути кілька. select повертає лямбда-вираз,
який, в разі виклику, виконує "вибірку" записів з таблиці, шлях до якої було
передано у select . При цьому лямбда-вираз в якості ключових параметрів може
отримати на вхід значення полів записів таблиці, для того щоб обмежити вибірку
лише заданими значеннями. Вибірка повертається у
вигляді списку записів.
4. Написати утиліту(-и) для запису вибірки (списку записів) у файл.
5. Написати функції для конвертування записів у інший тип 
6. Написати функцію(-ї) для "красивого" виводу записів таблиці (pretty-print).


## Варіант 2
База даних: Виробництво дронів.

Тип записів: Геш-таблиця.

## Лістинг реалізації завдання
```lisp
(defparameter *base-path* "D:/PROGRAMS/portacle/portacle/projects/Lab5/")

(defun get-full-path (filename)
  (concatenate 'string *base-path* filename))

(defun trim-whitespace (str)
  (string-trim '(#\Space #\Tab #\Newline #\Return) str))

(defun split-csv-line (string)
  (let ((result '())
        (start 0)
        (len (length string)))
    (loop
      (let ((comma-pos (position #\, string :start start)))
        (if comma-pos
            (progn
              (push (trim-whitespace (subseq string start comma-pos)) result)
              (setf start (1+ comma-pos)))
            (progn
              (push (trim-whitespace (subseq string start len)) result)
              (return (nreverse result))))))))

(defun parse-int-safe (str)
  (if (and (> (length str) 0) (every #'digit-char-p str))
      (parse-integer str)
      str))

(defun truncate-string (obj width)
  (let ((str (format nil "~a" obj)))
    (if (> (length str) width)
        (format nil "~a.." (subseq str 0 (- width 2)))
        str)))

(defun make-manufacturer (row-data)
  (let ((ht (make-hash-table :test 'eq)))
    (setf (gethash :type ht) :manufacturer)
    (setf (gethash :id ht) (parse-int-safe (nth 0 row-data)))
    (setf (gethash :name ht) (nth 1 row-data))
    (setf (gethash :country ht) (nth 2 row-data))
    (setf (gethash :year ht) (parse-int-safe (nth 3 row-data)))
    ht))

(defun make-drone (row-data)
  (let ((ht (make-hash-table :test 'eq)))
    (setf (gethash :type ht) :drone)
    (setf (gethash :id ht) (parse-int-safe (nth 0 row-data)))
    (setf (gethash :model ht) (nth 1 row-data))
    (setf (gethash :mfg-id ht) (parse-int-safe (nth 2 row-data)))
    (setf (gethash :year ht) (parse-int-safe (nth 3 row-data)))
    (setf (gethash :price ht) (parse-int-safe (nth 4 row-data)))
    ht))

(defun read-csv-file (filepath record-builder)
  (let ((records '()))
    (with-open-file (stream filepath :direction :input :if-does-not-exist nil)
      (if (null stream)
          (format t "ПОМИЛКА: Файл не знайдено: ~a~%" filepath)
          (loop for line = (read-line stream nil)
                while line
                do (let ((trimmed (trim-whitespace line)))
                     (when (> (length trimmed) 0)
                       (push (funcall record-builder (split-csv-line trimmed)) records))))))
    (nreverse records)))

(defun select (filename type-key)
  (let ((full-path (get-full-path filename))
        (builder (case type-key
                   (:manufacturer #'make-manufacturer)
                   (:drone #'make-drone)
                   (t (error "Невідомий тип запису")))))
    
    (lambda (&rest filters)
      (let ((all-records (read-csv-file full-path builder)))
        (if (null filters)
            all-records
            (remove-if-not 
             (lambda (rec)
               (loop for (key val) on filters by #'cddr
                     always (equal (gethash key rec) val)))
             all-records))))))

(defun hash-to-alist (ht)
  (let ((alist '()))
    (maphash (lambda (k v) (push (cons k v) alist)) ht)
    alist))

(defun print-line (width)
  (format t "+")
  (dotimes (i width) (format t "-"))
  (format t "+~%"))

(defun get-columns (type)
  (case type
    (:manufacturer '((:id "ID" 4) (:name "Компанія" 18) (:country "Країна" 12) (:year "Рік зас." 8)))
    (:drone          '((:id "ID" 4) (:model "Модель" 20) (:year "Рік вир." 8) (:price "Ціна" 8) (:mfg-id "MfgID" 6)))
    (t              '((:data "Дані" 40)))))

(defun print-table (records)
  (when (null records)
    (format t "Дані відсутні.~%")
    (return-from print-table))

  (let* ((sample (first records))
         (type (gethash :type sample))
         (columns (get-columns type))
         (total-width (+ 1 (loop for col in columns sum (+ (third col) 3)))))

    (format t "~%")
    (print-line (- total-width 2))
    
    (format t "|")
    (dolist (col columns)
      (format t " ~va |" (third col) (second col)))
    (format t "~%")
    (print-line (- total-width 2))

    (dolist (rec records)
      (format t "|")
      (dolist (col columns)
        (let ((val (gethash (first col) rec)))
          (format t " ~va |" (third col) (truncate-string val (third col)))))
      (format t "~%"))
    
    (print-line (- total-width 2))))

(defun save-to-file (filename records)
  (let ((full-path (get-full-path filename)))
    (with-open-file (stream full-path :direction :output 
                            :if-exists :supersede :if-does-not-exist :create)
      (dolist (rec records)
        (format stream "~a~%" (hash-to-alist rec))))))

(defun run ()
  (let ((drones-select (select "drones.csv" :drone))
        (mfg-select    (select "manufacturers.csv" :manufacturer)))

    (format t "~%Довідник виробників (manufacturers.csv):")
    (print-table (funcall mfg-select))

    (format t "~%Каталог дронів (drones.csv):")
    (print-table (funcall drones-select))

    (format t "~%Фільтр за виробниками з США:")
    (let ((usa-mfg (funcall mfg-select :country "USA")))
      (print-table usa-mfg)
      (save-to-file "sort_usa_manufacturers.txt" usa-mfg)
      (format t "Результат збережено у 'sort_usa_manufacturers.txt'~%"))

    (format t "~%Демонстрація конвертації (Hash -> Alist):")
    (let ((records (funcall drones-select)))
      (if records
          (let* ((original (first records))
                 (alist (hash-to-alist original)))
            
            (format t "~%Оригінал (Геш-таблиця):")
            (print-table (list original))
            
            (format t "~%Конвертація (Асоціативний список):~%")
            (dolist (pair alist)
              (format t "  ~20a -> ~a~%" (car pair) (cdr pair))))
          (format t "Немає даних.~%")))))
```
### Тестові набори та утиліти
```lisp
(defun check-result (name actual expected)
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal actual expected)
          name))

(defun run-tests ()
  (format t "~%МОДУЛЬНЕ ТЕСТУВАННЯ~%")
  
  (check-result "TEST 1 trim-whitespace" (trim-whitespace "  abc  ") "abc")
  (check-result "TEST 2 split-csv-line" (split-csv-line "1, DJI , China ") '("1" "DJI" "China"))
  (check-result "TEST 3 parse-int-safe" (parse-int-safe "2024") 2024)
  (check-result "TEST 4 parse-int-safe (string)" (parse-int-safe "NotNum") "NotNum")
  
  (let* ((row '("10" "TestDrone" "99" "2023" "500"))
         (drone (make-drone row)))
    (check-result "TEST 5 make-drone ID parsing" (gethash :id drone) 10)
    (check-result "TEST 6 make-drone Model mapping" (gethash :model drone) "TestDrone"))
  
  (let* ((ht (make-hash-table :test 'eq))
         (alist nil))
    (setf (gethash :a ht) 1)
    (setf alist (hash-to-alist ht))
    (check-result "TEST 7 hash-to-alist" (assoc :a alist) '(:a . 1))))
```
### Тестування
```lisp
МОДУЛЬНЕ ТЕСТУВАННЯ
passed... TEST 1 trim-whitespace
passed... TEST 2 split-csv-line
passed... TEST 3 parse-int-safe
passed... TEST 4 parse-int-safe (string)
passed... TEST 5 make-drone ID parsing
passed... TEST 6 make-drone Model mapping
passed... TEST 7 hash-to-alist

Довідник виробників (manufacturers.csv):
+-----------------------------------------------------+
| ID   | Компанія           | Країна       | Рік зас. |
+-----------------------------------------------------+
| 1    | DJI                | China        | 2006     |
| 2    | Skydio             | USA          | 2014     |
| 3    | Parrot             | France       | 1994     |
| 4    | Ukrspecsystems     | Ukraine      | 2014     |
| 5    | General Atomics    | USA          | 1955     |
+-----------------------------------------------------+

Каталог дронів (drones.csv):
+------------------------------------------------------------+
| ID   | Модель               | Рік вир. | Ціна     | MfgID  |
+------------------------------------------------------------+
| 1    | Mavic 3 Enterprise   | 2021     | 3200     | 1      |
| 2    | Mini 3 Pro           | 2022     | 800      | 1      |
| 3    | Skydio X2            | 2021     | 10000    | 2      |
| 4    | Anafi USA            | 2020     | 7000     | 3      |
| 5    | PD-2 VTOL            | 2020     | 30000    | 4      |
| 6    | MQ-9 Reaper          | 2007     | 32000000 | 5      |
+------------------------------------------------------------+

Фільтр за виробниками з США:
+-----------------------------------------------------+
| ID   | Компанія           | Країна       | Рік зас. |
+-----------------------------------------------------+
| 2    | Skydio             | USA          | 2014     |
| 5    | General Atomics    | USA          | 1955     |
+-----------------------------------------------------+
Результат збережено у 'sort_usa_manufacturers.csv'

Демонстрація конвертації (Hash -> Alist):
Оригінал (Геш-таблиця):
+------------------------------------------------------------+
| ID   | Модель               | Рік вир. | Ціна     | MfgID  |
+------------------------------------------------------------+
| 1    | Mavic 3 Enterprise   | 2021     | 3200     | 1      |
+------------------------------------------------------------+

Конвертація (Асоціативний список):
  PRICE                -> 3200
  YEAR                 -> 2021
  MFG-ID               -> 1
  MODEL                -> Mavic 3 Enterprise
  ID                   -> 1
  TYPE                 -> DRONE
```
