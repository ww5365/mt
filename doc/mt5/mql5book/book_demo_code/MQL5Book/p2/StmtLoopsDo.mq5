//+------------------------------------------------------------------+
//|                                                  StmtLoopsDo.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   double d = 1.0;
   do
   {
      Print(d);
      d *= M_SQRT2; // M_SQRT2  sqrt(2)  1.41421356237309504880
   }
   while(d < 100.0);
}
//+------------------------------------------------------------------+
