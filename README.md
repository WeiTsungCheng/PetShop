
####
內容: 
Composition Root + MVVM+ TableView
給個商品數量, 計算總額, 與設定喜歡

備註:
使用兩種方式處理 MVVM Input & OutPut
  a. enum ( git branch: Input_Ouput_Enum)
  b. struct ( git branch: Input_Ouput_Struct)
Cell 使用 CellController 持有 CellViewModel 與 Cell
CellViewModel 更動時的修改順序避免 Cell 點擊結果 在 reloadData() 後發生異常
####
