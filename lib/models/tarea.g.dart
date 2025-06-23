// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarea.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TareaAdapter extends TypeAdapter<Tarea> {
  @override
  final int typeId = 0;

  @override
  Tarea read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tarea(
      id: fields[0] as String,
      nombre: fields[1] as String,
      categoria: fields[2] as String,
      experiencia: fields[3] as double,
      imagenPath: fields[4] as String?,
      completadaEn: fields[5] as DateTime?,
      creadaEn: fields[6] as DateTime,
      clima: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Tarea obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.categoria)
      ..writeByte(3)
      ..write(obj.experiencia)
      ..writeByte(4)
      ..write(obj.imagenPath)
      ..writeByte(5)
      ..write(obj.completadaEn)
      ..writeByte(6)
      ..write(obj.creadaEn)
      ..writeByte(7)
      ..write(obj.clima);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TareaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
