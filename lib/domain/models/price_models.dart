class PriceEntry {
  final String ten;
  final String donVi;
  final String gia;
  final String? ghiChu;

  PriceEntry({
    required this.ten,
    required this.donVi,
    required this.gia,
    this.ghiChu,
  });

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      ten: json['ten']?.toString() ?? '',
      donVi: json['don_vi']?.toString() ?? '',
      gia: json['gia']?.toString() ?? '',
      ghiChu: json['ghi_chu']?.toString(),
    );
  }
}

class PriceItem {
  final String tenHangMuc;
  final List<PriceEntry> bangGia;

  PriceItem({
    required this.tenHangMuc,
    required this.bangGia,
  });

  factory PriceItem.fromJson(Map<String, dynamic> json) {
    final list = (json['bang_gia'] as List<dynamic>? ?? [])
        .map((e) => PriceEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return PriceItem(
      tenHangMuc: json['ten_hang_muc']?.toString() ?? '',
      bangGia: list,
    );
  }
}

class PriceGroup {
  final String nhomDichVuChinh;
  final List<PriceItem> danhSachHangMuc;

  PriceGroup({
    required this.nhomDichVuChinh,
    required this.danhSachHangMuc,
  });

  factory PriceGroup.fromJson(Map<String, dynamic> json) {
    final list = (json['danh_sach_hang_muc'] as List<dynamic>? ?? [])
        .map((e) => PriceItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return PriceGroup(
      nhomDichVuChinh: json['nhom_dich_vu_chinh']?.toString() ?? '',
      danhSachHangMuc: list,
    );
  }
}

