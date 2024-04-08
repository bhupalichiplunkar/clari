import { atomWithImmer } from "jotai-immer";
import { QUERY_CONSTANT_COLUMNS } from "../constants/table_constants";

export const queryDataAtom = atomWithImmer({
  data: [],
  page: 0,
  columns: QUERY_CONSTANT_COLUMNS,
});
