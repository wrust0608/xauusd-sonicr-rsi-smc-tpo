//+------------------------------------------------------------------+
//|                                                      VN_Lang.mqh |
//|                                  Copyright 2026, Antigravity AI  |
//|               Vietnamese Unicode Localization Engine for MT5     |
//+------------------------------------------------------------------+
#property copyright "Antigravity AI"

// Decodes UTF-8 hex string into native Unicode string at runtime
string VN(string hex)
{
   int len = StringLen(hex);
   if(len <= 0) return("");
   int n = len / 2;
   uchar b[];
   ArrayResize(b, n + 1);
   for(int i = 0; i < n; i++)
   {
      ushort c1 = StringGetCharacter(hex, i * 2);
      ushort c2 = StringGetCharacter(hex, i * 2 + 1);
      int v1 = (c1 >= '0' && c1 <= '9') ? (c1 - '0') : ((c1 >= 'a' && c1 <= 'f') ? (c1 - 'a' + 10) : (c1 - 'A' + 10));
      int v2 = (c2 >= '0' && c2 <= '9') ? (c2 - '0') : ((c2 >= 'a' && c2 <= 'f') ? (c2 - 'a' + 10) : (c2 - 'A' + 10));
      b[i] = (uchar)((v1 << 4) | v2);
   }
   b[n] = 0;
   return CharArrayToString(b, 0, n, CP_UTF8);
}

// Pre-compiled Vietnamese Constants
#define VN_SONIC_TITLE VN("48e1bb86205448e1bb904e4720534f4e4943205220284d3529") // "HỆ THỐNG SONIC R (M5)"
#define VN_H4_TREND_LABEL VN("58752068c6b0e1bb9b6e6720483420203a202573") // "Xu hướng H4  : %s"
#define VN_TREND_BULL_STRONG VN("54c4824e47204de1baa04e48") // "TĂNG MẠNH"
#define VN_TREND_BEAR_STRONG VN("4749e1baa24d204de1baa04e48") // "GIẢM MẠNH"
#define VN_TREND_SIDEWAYS VN("c49049204e47414e47202f2052e1bb9049") // "ĐI NGANG / RỐI"
#define VN_M15_WAIT_LABEL VN("4e68e1bb8b70206368e1bb9d204d3135203a202573") // "Nhịp chờ M15 : %s"
#define VN_M15_WAIT_BUY VN("43414e48204d5541202834302d353029") // "CANH MUA (40-50)"
#define VN_M15_WAIT_SELL VN("43414e482042c3814e202835302d363029") // "CANH BÁN (50-60)"
#define VN_M15_WAIT_SIGNAL VN("4348e1bb9c2054c38d4e204849e1bb8655") // "CHỜ TÍN HIỆU"
#define VN_M5_STRUCT_LABEL VN("43e1baa575207472c3ba63204d3520203a202573") // "Cấu trúc M5  : %s"
#define VN_M5_FINDING_WAVE VN("c490414e472054c38c4d2053c3934e47") // "ĐANG TÌM SÓNG"
#define VN_M5_BULL_WAVE VN("53c3934e472054c4824e4720284c2d482d484c29") // "SÓNG TĂNG (L-H-HL)"
#define VN_M5_BEAR_WAVE VN("53c3934e47204749e1baa24d2028482d4c2d4c4829") // "SÓNG GIẢM (H-L-LH)"
#define VN_M5_BULL_BOS VN("5048c3812056e1bba02054c4824e472028424f5329") // "PHÁ VỠ TĂNG (BOS)"
#define VN_M5_BEAR_BOS VN("5048c3812056e1bba0204749e1baa24d2028424f5329") // "PHÁ VỠ GIẢM (BOS)"
#define VN_DRAGON_DIST_LABEL VN("43c3a163682044e1baa3692052e1bb936e673a20252e3266206769c3a1") // "Cách Dải Rồng: %.2f giá"
#define VN_RADAR_LABEL VN("5261646172205068e1baa36e20e1bba96e673a202573") // "Radar Phản ứng: %s"
#define VN_RADAR_SCANNING VN("c490414e47205155c389542052c382552e2e2e") // "ĐANG QUÉT RÂU..."
#define VN_RADAR_BULL_REJ VN("e2ae9d2052c3ba742072c3a275204d75612074e1baa169202573") // "⮝ Rút râu Mua tại %s"
#define VN_RADAR_BEAR_REJ VN("e2ae9f2052c3ba742072c3a2752042c3a16e2074e1baa169202573") // "⮟ Rút râu Bán tại %s"
#define VN_ZONE_EMA200 VN("454d4120323030") // "EMA 200"
#define VN_ZONE_EMA89 VN("454d41203839") // "EMA 89"
#define VN_ZONE_DRAGON_HIGH VN("c490e1bb896e682052e1bb936e67") // "Đỉnh Rồng"
#define VN_ZONE_DRAGON_AXIS VN("5472e1bba5632052e1bb936e67") // "Trục Rồng"
#define VN_ZONE_DRAGON_LOW VN("c490c3a1792052e1bb936e67") // "Đáy Rồng"
#define VN_ZONE_LOWER_WICK VN("52c3a2752044c6b0e1bb9b69") // "Râu Dưới"
#define VN_ZONE_UPPER_WICK VN("52c3a275205472c3aa6e") // "Râu Trên"
#define VN_SLTP_WICK_LABEL VN("534c2f54502052c3a275206ee1babf6e203a2024252e3266202f2024252e3266") // "SL/TP Râu nến : $%.2f / $%.2f"
#define VN_SLTP_ATR_LABEL VN("534c2f54502047e1bba36920c3bd204154523a2024252e3266202f2024252e3266") // "SL/TP Gợi ý ATR: $%.2f / $%.2f"
#define VN_ALERT_BULL_REJ VN("5b42e1baae542052c3825520414c4552545d202573204d353a20e2ae9d2052c3ba742072c3a275204d75612028252e30662525292074e1baa169202573207c204769c3a13a20252e3266207c20534c3a20252e3266205b2d24252e32665d207c2054503a20252e3266205b2b24252e32665d2028525220313a3229") // "[BẮT RÂU ALERT] %s M5: ⮝ Rút râu Mua (%.0f%%) tại %s | Giá: %.2f | SL: %.2f [-$%.2f] | TP: %.2f [+$%.2f] (RR 1:2)"
#define VN_ALERT_BEAR_REJ VN("5b42e1baae542052c3825520414c4552545d202573204d353a20e2ae9f2052c3ba742072c3a2752042c3a16e2028252e30662525292074e1baa169202573207c204769c3a13a20252e3266207c20534c3a20252e3266205b2b24252e32665d207c2054503a20252e3266205b2d24252e32665d2028525220313a3229") // "[BẮT RÂU ALERT] %s M5: ⮟ Rút râu Bán (%.0f%%) tại %s | Giá: %.2f | SL: %.2f [+$%.2f] | TP: %.2f [-$%.2f] (RR 1:2)"
#define VN_RSI_LEVEL_30 VN("5175c3a12062c3a16e205b33305d") // "Quá bán [30]"
#define VN_RSI_LEVEL_40 VN("48e1bb97207472e1bba32074c4836e67205b34305d") // "Hỗ trợ tăng [40]"
#define VN_RSI_LEVEL_50 VN("43c3a26e2062e1bab16e67205b35305d") // "Cân bằng [50]"
#define VN_RSI_LEVEL_60 VN("4b68c3a16e672063e1bbb1206769e1baa36d205b36305d") // "Kháng cự giảm [60]"
#define VN_RSI_LEVEL_70 VN("5175c3a1206d7561205b37305d") // "Quá mua [70]"
#define VN_RSI_HUD_H4H1 VN("48343a20257320284269c3aa6e3a252e316629207c2048313a20257320284269c3aa6e3a252e316629") // "H4: %s (Biên:%.1f) | H1: %s (Biên:%.1f)"
#define VN_RSI_HUD_M15 VN("4d31353a202573205b5253493a20252e3166207c20574d413a20252e31665d") // "M15: %s [RSI: %.1f | WMA: %.1f]"
#define VN_RSI_HUD_CARDWELL VN("48c3a06e68206c616e67204361726477656c6c3a202573") // "Hành lang Cardwell: %s"
#define VN_RSI_HUD_LATCH VN("5472e1baa16e67207468c3a169204d353a204b68c3b361204d75613d2573207c204b68c3b3612042c3a16e3d2573") // "Trạng thái M5: Khóa Mua=%s | Khóa Bán=%s"
#define VN_STATE_ON VN("42e1baac54") // "BẬT"
#define VN_STATE_OFF VN("54e1baae54") // "TẮT"
#define VN_RSI_WAIT_BUY VN("43414e48204d5541202834302d353029") // "CANH MUA (40-50)"
#define VN_RSI_WAIT_SELL VN("43414e482042c3814e202835302d363029") // "CANH BÁN (50-60)"
#define VN_RSI_OUTSIDE VN("4e474fc380492056c3994e47") // "NGOÀI VÙNG"
#define VN_CARDWELL_BULL VN("48c3804e48204c414e472054c4824e47202834302d383029") // "HÀNH LANG TĂNG (40-80)"
#define VN_CARDWELL_BEAR VN("48c3804e48204c414e47204749e1baa24d202832302d363029") // "HÀNH LANG GIẢM (20-60)"
#define VN_CARDWELL_RANGE VN("c49049204e47414e47202f2043485559e1bb824e20504841") // "ĐI NGANG / CHUYỂN PHA"
#define VN_DIV_REG_BULL VN("5068c3a26e206be1bbb32054c4836e67") // "Phân kỳ Tăng"
#define VN_DIV_HID_BULL VN("5068c3a26e206be1bbb32054c4836e6720e1baa86e") // "Phân kỳ Tăng Ẩn"
#define VN_DIV_DB VN("525349203220c490c3a179") // "RSI 2 Đáy"
#define VN_DIV_REG_BEAR VN("5068c3a26e206be1bbb3204769e1baa36d") // "Phân kỳ Giảm"
#define VN_DIV_HID_BEAR VN("5068c3a26e206be1bbb3204769e1baa36d20e1baa86e") // "Phân kỳ Giảm Ẩn"
#define VN_DIV_DT VN("525349203220c490e1bb896e68") // "RSI 2 Đỉnh"
#define VN_SMC_OB_BUY VN("4f42204d7561") // "OB Mua"
#define VN_SMC_OB_SELL VN("4f422042c3a16e") // "OB Bán"
#define VN_SMC_FVG_BUY VN("465647204d7561") // "FVG Mua"
#define VN_SMC_FVG_SELL VN("4656472042c3a16e") // "FVG Bán"
#define VN_SMC_EQH VN("24242420c490e1bb896e682042e1bab16e67202845514829") // "$$$ Đỉnh Bằng (EQH)"
#define VN_SMC_EQL VN("24242420c490c3a1792042e1bab16e67202845514c29") // "$$$ Đáy Bằng (EQL)"
#define VN_SMC_SFP VN("53465020285175c3a9742052c3a27529") // "SFP (Quét Râu)"
#define VN_SMC_EQ VN("3530252043c3a26e2042e1bab16e672028455129") // "50% Cân Bằng (EQ)"
#define VN_SMC_EQ_FMT VN("20203530252043c3a26e2042e1bab16e673a20252e3266") // "  50% Cân Bằng: %.2f"
#define VN_SMC_BOS_BULL VN("424f532054c4836e67") // "BOS Tăng"
#define VN_SMC_BOS_BEAR VN("424f53204769e1baa36d") // "BOS Giảm"
#define VN_SMC_CHOCH_BULL VN("43486f43482054c4836e67") // "CHoCH Tăng"
#define VN_SMC_CHOCH_BEAR VN("43486f4348204769e1baa36d") // "CHoCH Giảm"
#define VN_SMC_TITLE VN("43e1baa455205452c39a4320534d4320284d3529") // "CẤU TRÚC SMC (M5)"
#define VN_SMC_TREND_LABEL VN("c490e1bb8b6e682068c6b0e1bb9b6e67203a202573") // "Định hướng : %s"
#define VN_SMC_TREND_BULL VN("54c4824e472028424f5329") // "TĂNG (BOS)"
#define VN_SMC_TREND_BEAR VN("4749e1baa24d2028424f5329") // "GIẢM (BOS)"
#define VN_SMC_TREND_RANGE VN("c49049204e47414e47202f205452554e472054c38d4e48") // "ĐI NGANG / TRUNG TÍNH"
#define VN_SMC_RANGE_LABEL VN("4269c3aa6e20c491e1bb99202020203a20252e3166202d20252e3166207c2043c3a26e2062e1bab16e673a20252e3166") // "Biên độ    : %.1f - %.1f | Cân bằng: %.1f"
#define VN_SMC_ZONE_LABEL VN("56c3b96e67206769c3a12020203a202573207c204f423a2025642f2564207c204656473a202564") // "Vùng giá   : %s | OB: %d/%d | FVG: %d"
#define VN_SMC_ZONE_PREMIUM VN("56c3b96e6720c490e1baaf74") // "Vùng Đắt"
#define VN_SMC_ZONE_DISCOUNT VN("56c3b96e672052e1babb") // "Vùng Rẻ"
#define VN_SMC_ZONE_EQ VN("43c3a26e2042e1bab16e67") // "Cân Bằng"
#define VN_TPO_ASIA_NAME VN("506869c3aa6e20c381") // "Phiên Á"
#define VN_TPO_LONDON_NAME VN("506869c3aa6e20c38275") // "Phiên Âu"
#define VN_TPO_NY_NAME VN("506869c3aa6e204de1bbb9") // "Phiên Mỹ"
#define VN_TPO_POC_FMT VN("257320504f433a20252e3266") // "%s POC: %.2f"
#define VN_TPO_VAH_FMT VN("2573205641483a20252e3266") // "%s VAH: %.2f"
#define VN_TPO_VAL_FMT VN("25732056414c3a20252e3266") // "%s VAL: %.2f"
#define VN_TPO_POOR_HIGH VN("c490e1bb896e682059e1babf75") // "Đỉnh Yếu"
#define VN_TPO_POOR_LOW VN("c490c3a1792059e1babf75") // "Đáy Yếu"
#define VN_TPO_TITLE VN("48e1bb922053c6a0204b48e1bb9049204cc6afe1bba24e4720504849c38a4e202854504f29") // "HỒ SƠ KHỐI LƯỢNG PHIÊN (TPO)"
#define VN_TPO_STATUS_LABEL VN("5472e1baa16e67207468c3a16920706869c3aa6e3a202573") // "Trạng thái phiên: %s"
