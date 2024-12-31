;nyquist plug-in
;version 4
;type process
;preview linear
;name "Spatial Pitch Separation"
;debugbutton enabled
;author "Michael Peters"
;release 1.0
;copyright "GNU General Public License v2.0"

;; License: GPL v2
;; http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
;;
;; For information about writing and modifying Nyquist plug-ins:
;; https://wiki.audacityteam.org/wiki/Nyquist_Plug-ins_Reference

;control FREQUENCY "Center Frequency (Hz)" float-text "" 440 0 nil
;control ORIENTATION "Pan Orientation" choice "Bass on left,Bass on right" 0
;control ROLLOFF "Roll-off (dB per octave)" choice "6 dB,12 dB,24 dB,36 dB,48 dB" 0

(defun lowpass-cutoff (center rolloff)
  (let*
    (
      (decades-to-3db (/ -0.0 rolloff))
    )
    (* center (power 10.0 decades-to-3db))
  )
)

(defun highpass-cutoff (center rolloff)
  (let*
    (
      (decades-to-3db (/ 0.0 rolloff))
    )
    (* center (power 10.0 decades-to-3db))
  )
)

(defun process-track (sound)
  (let*
    (
      (highpass-selection (nth ROLLOFF '(hp highpass2 highpass4 highpass6 highpass8) ))
      (lowpass-selection (nth ROLLOFF '(lp lowpass2 lowpass4 lowpass6 lowpass8) ))
      (rolloff-selection (nth ROLLOFF '(6 12 24 36 48) ))
    )
    (if (= ORIENTATION 0)
      (vector
        (funcall lowpass-selection sound (lowpass-cutoff FREQUENCY rolloff-selection))
        (funcall highpass-selection sound (highpass-cutoff FREQUENCY rolloff-selection))
      )
      (vector
        (funcall highpass-selection sound (highpass-cutoff FREQUENCY rolloff-selection))
        (funcall lowpass-selection sound (lowpass-cutoff FREQUENCY rolloff-selection))
      )
    )
  )
)

(let*
  (
    (nyquist-limit (/ *sound-srate* 2.0))
  )
  (if (< FREQUENCY 0.1) 
    (print 
      (format nil "ERROR: Selected center frequency (~a Hz) is too low, must be >0.1 Hz" FREQUENCY)
    )
    (if (> FREQUENCY nyquist-limit)
      (print 
        (format nil "ERROR: Selected center frequency (~a Hz) must be below half of track sample rate (~a Hz)" FREQUENCY nyquist-limit)
      )
      (if (arrayp *track*)
        (process-track (scale 0.5 (to-mono *track*)))
        (print "ERROR: cannot process mono input!")
      )
    )
  )
)