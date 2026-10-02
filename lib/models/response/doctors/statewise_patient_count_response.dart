class StatewisePatientCountResponse {
  final String status;
  final String msg;
  final String referIn;
  final String inProcess;
  final String onHold;
  final String serve;
  final String referOut;
  final String scheduleToday;
  final String scheduleMissed;
  final String scheduleImp;

  StatewisePatientCountResponse({
    this.status = '',
    this.msg = '',
    this.referIn = '0',
    this.inProcess = '0',
    this.onHold = '0',
    this.serve = '0',
    this.referOut = '0',
    this.scheduleToday = '0',
    this.scheduleMissed = '0',
    this.scheduleImp = '0',
  });

  factory StatewisePatientCountResponse.fromJson(Map<String, dynamic> json) {
    return StatewisePatientCountResponse(
      status: json['status']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      referIn: json['refer_in']?.toString() ?? '0',
      inProcess: json['in_process']?.toString() ?? '0',
      onHold: json['on_hold']?.toString() ?? '0',
      serve: json['serve']?.toString() ?? '0',
      referOut: json['refer_out']?.toString() ?? '0',
      scheduleToday: json['schedule_today']?.toString() ?? '0',
      scheduleMissed: json['schedule_missed']?.toString() ?? '0',
      scheduleImp: json['schedule_imp']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'refer_in': referIn,
      'in_process': inProcess,
      'on_hold': onHold,
      'serve': serve,
      'refer_out': referOut,
      'schedule_today': scheduleToday,
      'schedule_missed': scheduleMissed,
      'schedule_imp': scheduleImp,
    };
  }
}
