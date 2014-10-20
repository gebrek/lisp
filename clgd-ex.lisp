(require 'cl-gd)
(use-package 'cl-gd)

(with-image* (200 200)
  (allocate-color 68 70 85)
  (let ((beige (allocate-color 222 200 81))
        (brown (allocate-color 206 150 75))
        (green (allocate-color 104 156 84))
        (red (allocate-color 163 83 84))
        (white (allocate-color 255 255 255))
        (two-pi (* 2 pi)))
    (with-transformation (:x1 -100 :x2 100 :y1 -100 :y2 100 :radians t)
      (draw-arc 0 0 130 130 0 (* .6 two-pi)
                :center-connect t :filled t :color beige)
      (draw-arc 0 0 130(* .6 two-pi) (* .8 two-pi)
                :center-connect t :filled t :color brown)
      (draw-arc 0 0 130 130 (* .8 two-pi) (* .95 two-pi)
                :center-connect t :filled t :color green)
      (draw-arc 0 0 130 130 (* .95 two-pi) two-pi
                :center-connect t :filled t :color red)
      (with-default-color (white)
        (with-default-font (:small)
          (draw-string -8 -30 "60%")
          (draw-string -20 40 "20%")
          (draw-string 20 30 "15%"))
        (draw-freetype-string -90 75 "Global Revenue"
                              ;; this assumes that 'DEFAULT_FONTPATH'
                              ;; is set correctly
                              :font-name "verdanab"))))
  (write-image-to-file "chart.png"
                       :compression-level 6 :if-exists :supersede))
