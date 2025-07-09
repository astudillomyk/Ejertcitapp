import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/tareas_service.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  // Función para mapear descripción de clima a colores
  Color _colorPorClima(String descripcion) {
    final desc = descripcion.toLowerCase();
    if (desc.contains('lluvia') || desc.contains('rain')) return Colors.blue.shade700;
    if (desc.contains('nublado') || desc.contains('cloud')) return Colors.grey.shade600;
    if (desc.contains('soleado') || desc.contains('clear')) return Colors.orange.shade400;
    if (desc.contains('tormenta') || desc.contains('storm')) return Colors.deepPurple.shade700;
    if (desc.contains('nieve') || desc.contains('snow')) return Colors.lightBlue.shade100;
    return Colors.green.shade400; // default
  }

  @override
  Widget build(BuildContext context) {
    final tareas = Provider.of<TareasService>(context).tareas;
    final completadas = tareas.where((t) => t.completadaEn != null).toList();
    final inconclusas = tareas.where((t) => t.completadaEn == null).toList();

    final experienciaPorDia = <String, double>{};
    final temperaturaPorDia = <String, double>{};
    final descripcionPorDia = <String, String>{};

    for (var tarea in completadas) {
      final dia = DateFormat('yyyy-MM-dd').format(tarea.completadaEn!);
      experienciaPorDia[dia] = (experienciaPorDia[dia] ?? 0) + tarea.experiencia;

      final clima = tarea.clima ?? '';
      if (clima.contains(',')) {
        final partes = clima.split(',');
        final descripcion = partes[0].trim();
        final tempStr = partes[1].replaceAll('°C', '').trim();
        final temp = double.tryParse(tempStr) ?? 0;
        temperaturaPorDia[dia] = temp;
        descripcionPorDia[dia] = descripcion;
      } else {
        temperaturaPorDia[dia] = 0;
        descripcionPorDia[dia] = '';
      }
    }

    final pieData = [
      PieChartSectionData(
        value: completadas.length.toDouble(),
        color: Colors.green,
        title: 'Completadas',
      ),
      PieChartSectionData(
        value: inconclusas.length.toDouble(),
        color: Colors.red,
        title: 'Inconclusas',
      ),
    ];

    final lineSpots = experienciaPorDia.entries.map((e) {
      final x = experienciaPorDia.keys.toList().indexOf(e.key).toDouble();
      return FlSpot(x, e.value);
    }).toList();

    // Gráfico barras temperatura
    final barGroupsTemperatura = temperaturaPorDia.entries.map((e) {
      final index = temperaturaPorDia.keys.toList().indexOf(e.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: e.value, width: 20, color: Colors.orange),
        ],
      );
    }).toList();

    // Gráfico barras clima categórico con etiquetas texto
    final barGroupsClima = descripcionPorDia.entries.map((e) {
      final index = descripcionPorDia.keys.toList().indexOf(e.key);
      final color = _colorPorClima(e.value);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: 1, width: 20, color: color),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    Widget bottomTitleWidgets(List<String> keys, double value) {
      if (value.toInt() < keys.length) {
        return Text(keys[value.toInt()].substring(5));
      }
      return const Text('');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil y Progreso')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tareas completadas vs inconclusas:'),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(sections: pieData)),
            ),
            const SizedBox(height: 20),
            const Text('Experiencia acumulada por día:'),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: lineSpots,
                      dotData: FlDotData(show: true),
                      color: Colors.blue,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            bottomTitleWidgets(experienciaPorDia.keys.toList(), value),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Temperatura por día (°C):'),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: barGroupsTemperatura,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            bottomTitleWidgets(temperaturaPorDia.keys.toList(), value),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Clima por día:'),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: 1.2,
                  barGroups: barGroupsClima,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            bottomTitleWidgets(descripcionPorDia.keys.toList(), value),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),

                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final fecha = descripcionPorDia.keys.toList()[group.x.toInt()];
                        final clima = descripcionPorDia[fecha] ?? '';
                        return BarTooltipItem(
                          clima,
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: descripcionPorDia.entries.map((e) {
                  return SizedBox(
                    width: 20,
                    child: Text(
                      e.value,
                      style: const TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
