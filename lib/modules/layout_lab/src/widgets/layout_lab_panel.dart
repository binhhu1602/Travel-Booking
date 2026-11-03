import 'package:flutter/material.dart';
import 'package:travel_booking/modules/hotel_detail/hotel_detail.dart';

import '../models/lab_config.dart';

class LayoutLabPanel extends StatelessWidget {
  const LayoutLabPanel({
    super.key,
    required this.config,
    required this.onChanged,
  });

  /// Các giá trị của CrossAxisAlignment dùng được cho hàng thống kê.
  /// Không có baseline vì giá trị này bắt buộc phải khai báo textBaseline.
  static const List<CrossAxisAlignment> crossOptions = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
    CrossAxisAlignment.end,
    CrossAxisAlignment.stretch,
  ];

  final LabConfig config;

  // Widget con không tự giữ trạng thái: chỉ báo cấu hình mới lên cho cha.
  final ValueChanged<LabConfig> onChanged;

  String get _flexHint {
    if (!config.handleOverflow) {
      return 'Đang dùng Row thường với thẻ rộng cố định, lựa chọn này tạm tắt.';
    }
    return config.flexMode == FlexDemoMode.expanded
        ? 'Expanded chiếm hết chỗ trống nên MainAxisAlignment không đổi gì. '
              'Chọn Flexible để thấy khác biệt.'
        : 'Thẻ chỉ rộng vừa nội dung, chỗ trống còn lại được phân bổ theo '
              'MainAxisAlignment.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Layout Lab', style: theme.textTheme.titleLarge),
            ),
            TextButton.icon(
              onPressed: () => onChanged(const LabConfig()),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Đặt lại'),
            ),
          ],
        ),
        const _LabHeading('Chiều rộng khung xem trước'),
        Text(
          '${config.previewWidth.round()} px · '
          '${config.isTwoColumn ? '2 cột (LayoutBuilder > 600px)' : '1 cột'}',
          style: theme.textTheme.bodySmall,
        ),
        Slider(
          min: kMinPreviewWidth,
          max: kMaxPreviewWidth,
          divisions: 66,
          value: config.previewWidth,
          label: '${config.previewWidth.round()} px',
          onChanged: (value) => onChanged(config.copyWith(previewWidth: value)),
        ),
        const _LabHeading('Căn chỉnh hàng thống kê'),
        _DropdownField<MainAxisAlignment>(
          label: 'MainAxisAlignment (đỏ)',
          value: config.mainAxisAlignment,
          options: MainAxisAlignment.values,
          optionLabel: (option) => option.name,
          onChanged: (value) =>
              onChanged(config.copyWith(mainAxisAlignment: value)),
        ),
        _DropdownField<CrossAxisAlignment>(
          label: 'CrossAxisAlignment (xanh)',
          value: config.crossAxisAlignment,
          options: crossOptions,
          optionLabel: (option) => option.name,
          onChanged: (value) =>
              onChanged(config.copyWith(crossAxisAlignment: value)),
        ),
        const _LabHeading('Flexible loose và Expanded'),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<FlexDemoMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: FlexDemoMode.flexibleLoose,
                label: Text('Flexible (loose)'),
              ),
              ButtonSegment(
                value: FlexDemoMode.expanded,
                label: Text('Expanded'),
              ),
            ],
            selected: {config.flexMode},
            // onSelectionChanged = null: SegmentedButton chuyển sang trạng thái
            // vô hiệu hóa, vì khi tắt xử lý overflow hàng này là Row thường.
            onSelectionChanged: config.handleOverflow
                ? (selection) =>
                      onChanged(config.copyWith(flexMode: selection.first))
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(_flexHint, style: theme.textTheme.bodySmall),
        const _LabHeading('Tăng nội dung'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Tên khách sạn siêu dài'),
          value: config.useLongName,
          onChanged: (value) => onChanged(config.copyWith(useLongName: value)),
        ),
        OutlinedButton(
          onPressed: () => onChanged(
            config.copyWith(extraAmenities: config.extraAmenities + 1),
          ),
          child: Text(
            '+ Thêm tiện ích (${buildAmenities(config.extraAmenities).length})',
          ),
        ),
        const _LabHeading('Xử lý overflow'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Bật xử lý overflow'),
          subtitle: Text(
            'Tắt: dùng Row, Column thường và thấy vạch sọc vàng-đen '
            '(chỉ hiện ở debug mode).\n'
            'Bật: dùng Expanded, Wrap, ellipsis, SingleChildScrollView.',
            style: theme.textTheme.bodySmall,
          ),
          value: config.handleOverflow,
          onChanged: (value) =>
              onChanged(config.copyWith(handleOverflow: value)),
        ),
      ],
    );
  }
}

class _LabHeading extends StatelessWidget {
  const _LabHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T option) optionLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        // isExpanded: dropdown rộng bằng cha, tên dài không làm tràn hàng.
        DropdownButton<T>(
          isExpanded: true,
          value: value,
          style: Theme.of(context).textTheme.bodyMedium,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(optionLabel(option))),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}
