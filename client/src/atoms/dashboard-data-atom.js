import { atomWithImmer } from "jotai-immer";

export const dashboardDataAtom = atomWithImmer({
  data: [],
  page: 0,
  level: null,
});
