const MAP_LT = {
  BEGINNER: 1,
  INTERMEDIATE: 2,
  ADVANCED: 3,
  PROFESSIONAL: 4,
};

function compareCate(a, b) {
  const a_lt = MAP_LT[`${a.levelType}`];
  const b_lt = MAP_LT[`${b.levelType}`];
  if (a_lt < b_lt) {
    return -1;
  } else if (a_lt > b_lt) {
    return 1;
  } else {
    if (a["name"] < b["name"]) {
      return -1;
    } else if (a["name"] > b["name"]) {
      return 1;
    }
    return 0;
  }
}

function compareLess(a, b) {
  if (a.subCategoryId != undefined && b.subCategoryId != undefined) {
    if (a.subCategoryId.name < b.subCategoryId.name) {
      return -1;
    } else if (a.subCategoryId.name > b.subCategoryId.name) {
      return 1;
    } else {
      if (a.name < b.name) {
        return -1;
      } else if (a.name > b.name) {
        return 1;
      }
      return 0;
    }
  } else {
    if (a.name < b.name) {
      return -1;
    } else if (a.name > b.name) {
      return 1;
    }
    return 0;
  }
}

function compareScore(a, b) {
  if (a.point > b.point) {
    return -1;
  } else if (a.point == b.point) {
    return 0;
  } else {
    return 1;
  }
}

module.exports = {
  compareCate: compareCate,
  compareLess: compareLess,
  compareScore: compareScore
};
