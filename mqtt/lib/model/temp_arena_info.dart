class TempArenaInfo {
  TempArenaInfo({
    required this.clientVersionFromXml,
    required this.gameMode,
    required this.clientVersionFromExe,
    required this.scenarioUiCategoryId,
    required this.mapDisplayName,
    required this.mapId,
    required this.matchGroup,
    required this.weatherParams,
    required this.duration,
    required this.gameLogic,
    required this.name,
    required this.scenario,
    required this.playerId,
    required this.vehicles,
    required this.playersPerTeam,
    required this.dateTime,
    required this.mapName,
    required this.playerName,
    required this.scenarioConfigId,
    required this.teamsCount,
    required this.logic,
    required this.playerVehicle,
  });

  final String clientVersionFromXml;
  final int gameMode;
  final String clientVersionFromExe;
  final int scenarioUiCategoryId;
  final String mapDisplayName;
  final int mapId;
  final String matchGroup;
  final Map<String, List<String>> weatherParams;
  final int duration;
  final String gameLogic;
  final String name;
  final String scenario;
  final int playerId;
  final List<Vehicle> vehicles;
  final int playersPerTeam;
  final String dateTime;
  final String mapName;
  final String playerName;
  final int scenarioConfigId;
  final int teamsCount;
  final String logic;
  final String playerVehicle;

  factory TempArenaInfo.fromJson(Map<String, dynamic> json) => TempArenaInfo(
        clientVersionFromXml: json['clientVersionFromXml'],
        gameMode: json['gameMode'],
        clientVersionFromExe: json['clientVersionFromExe'],
        scenarioUiCategoryId: json['scenarioUiCategoryId'],
        mapDisplayName: json['mapDisplayName'],
        mapId: json['mapId'],
        matchGroup: json['matchGroup'],
        weatherParams: Map.from(json['weatherParams']).map(
            (k, v) => MapEntry<String, List<String>>(k, List<String>.from(v))),
        duration: json['duration'],
        gameLogic: json['gameLogic'],
        name: json['name'],
        scenario: json['scenario'],
        playerId: json['playerID'],
        vehicles: List<Vehicle>.from(
            json['vehicles'].map((x) => Vehicle.fromJson(x))),
        playersPerTeam: json['playersPerTeam'],
        dateTime: json['dateTime'],
        mapName: json['mapName'],
        playerName: json['playerName'],
        scenarioConfigId: json['scenarioConfigId'],
        teamsCount: json['teamsCount'],
        logic: json['logic'],
        playerVehicle: json['playerVehicle'],
      );
}

class Vehicle {
  Vehicle({
    required this.shipId,
    required this.relation,
    required this.id,
    required this.name,
  });

  final int shipId;
  final int relation;
  final int id;
  final String name;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        shipId: json['shipId'],
        relation: json['relation'],
        id: json['id'],
        name: json['name'],
      );
}
