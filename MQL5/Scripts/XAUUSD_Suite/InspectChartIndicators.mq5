//+------------------------------------------------------------------+
//|                                     InspectChartIndicators.mq5   |
//+------------------------------------------------------------------+
#property script_show_inputs false

void OnStart()
{
   int fileHandle = FileOpen("inspect_chart.txt", FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE) return;

   long chartId = ChartID();
   int totalObj = ObjectsTotal(chartId, 0, -1);
   FileWriteString(fileHandle, StringFormat("Total objects: %d\n", totalObj));
   for(int i = 0; i < totalObj; i++)
   {
      string name = ObjectName(chartId, i);
      long type = ObjectGetInteger(chartId, name, OBJPROP_TYPE);
      if(type == OBJ_LABEL || type == OBJ_RECTANGLE_LABEL || type == OBJ_TEXT)
      {
         long corner = ObjectGetInteger(chartId, name, OBJPROP_CORNER);
         long x = ObjectGetInteger(chartId, name, OBJPROP_XDISTANCE);
         long y = ObjectGetInteger(chartId, name, OBJPROP_YDISTANCE);
         string txt = ObjectGetString(chartId, name, OBJPROP_TEXT);
         FileWriteString(fileHandle, StringFormat("%s (t=%d, c=%d, x=%d, y=%d): '%s'\n", name, type, corner, x, y, txt));
      }
   }
   FileClose(fileHandle);
}
