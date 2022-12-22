/***
 * The algorithm to calculate SM-2
 *
 * @param quality: integer
 * 5 - perfect response
 * 4 - correct response after a hesitation
 * 3 - correct response recalled with serious difficulty
 * 2 - incorrect response; where the correct one seemed easy to recall
 * 1 - incorrect response; the correct one remembered
 * 0 - complete blackout.
 *
 *
 * @param repetitions: integer
 *
 *
 * @param previousInterval: float
 *
 *
 * @param previousEaseFactor: integer
 *
 *
 * @returns {{easeFactor: number, interval: number, repetitions: number}}
 *
 *         STUDY_NEW
 *         STUDY_REV
 *         STUDY_FORGOT
 *         STUDY_AHEAH
 *         STUDY_RANDOM
 *         STUDY_PREVIEW
 *         STUDY_TAGS
 *
 *   CARD TYPE:
 *   CARD_TYPE_NEW if interval = 0, CARD_TYPE_YOUNG if interval 1-20, CARD_TYPE_MATURE if interval >= 20
 */
const calculate = (quality, repetitions, previousInterval, previousEaseFactor) => {
  let interval;
  let easeFactor;

  if (quality >= 3) {
    switch (repetitions) {
    case 0:
      interval = 1;
      break;
    case 1:
      interval = 6;
      break;
    default:
      interval = (previousInterval * previousEaseFactor).round();
    }

    repetitions++;
    easeFactor = previousEaseFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));

  } else {
    repetitions = 0;
    interval = 1;
    easeFactor = previousEaseFactor;
  }

  if (easeFactor < 1.3) {
    easeFactor = 1.3;
  }

  return {
    interval,
    repetitions,
    easeFactor
  };
};

module.exports = {
  calculate
};
