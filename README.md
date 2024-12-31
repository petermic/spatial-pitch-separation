# spatial-pitch-separation
Audacity Nyquist plugin that spatially separates pitches in stereo, as a transcription aid

Often when transcribing pieces, it's much easier to figure out what's going on when different pitches are spatially separated via stereo panning. This Audacity plugin does exactly that: for an arbitrary stereo track, it pans lower frequencies to the left and higher frequencies to the right (or vice versa, as per your preference).

## Installation
To install this plugin:

1. Open Audacity.
2. Navigate to Tools->Nyquist Plugin Installer...
3. Select `spsep.ny` within this directory, and proceed with installation.

Enable this plugin via Effects->Plugin Manager. It should appear in Effects, as "Spatial Pitch Separation."

## Usage
This plugin currently has three controls:

- **Center Frequency** (in Hz) controls where the low-vs-high stereo split is centered. This parameter must be greater than 0.1 Hz and less than half the sample rate. Preliminary testing shows that the typical range for this parameter is somewhere between 300 Hz (for bass-heavy tracks) and 1000 Hz (which tends to center vocals).
- **Pan Orientation** controls whether bass is panned to the left (and treble to the right) or vice versa. If using this tool for long periods, switching the orientation occasionally tends to be easier on the ears.
- **Rolloff** controls the slope of the filters used to produce the stereo panning. The higher the rolloff, the more steeply sloped the filter's frequency response, and therefore the more aggressively pitches will be panned away from center. The "6 dB per octave" setting is recommended to start with, since it minimizes distortion; higher rolloff settings may isolate center pitches more, but also tend to distort the overall sound, boosting frequencies near the center.

## Notes
- Due to how Nyquist works in Audacity, the input track must be stereo to begin with. Nyquist cannot (to my knowledge, anyway) produce a stereo output track from a mono input track.
- The first step in this plugin's processing is to convert the input track to mono; interference-based effects are currently not accounted for (no re-normalization is currently done), and any pre-existing stereo panning in the input will not affect the output.
