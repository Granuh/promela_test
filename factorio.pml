#define INITIAL_RES 4
#define COAL_ORE_ID 1
#define IRON_ORE_ID 2
#define COPPER_ORE_ID 3
#define IRON_INGOT_ID 4
#define COPPER_INGOT_ID 5
#define IRON_GEAR_ID 6
#define COPPER_GEAR_ID 7

// Каналы: секции -> буры (по одной секции на индекс)
chan cCoalOre_to_drills[4] = [4] of { byte };
chan cIronOre_to_drills[4] = [4] of { byte };
chan cCopperOre_to_drills[4] = [4] of { byte };

// Буры -> печи
chan cDrills_to_furnace_coal = [16] of { byte };
chan cDrills_to_furnace_iron = [16] of { byte };
chan cDrills_to_furnace_copper = [16] of { byte };

// Печи -> слитки
chan cFurnace_to_ingots_iron = [8] of { byte };
chan cFurnace_to_ingots_copper = [8] of { byte };

// Слитки -> шестерни
chan cIngots_to_gear_iron = [8] of { byte };
chan cIngots_to_gear_copper = [8] of { byte };

// Ресурсы: по 4 в каждой из 4 секций → всего 16 единиц каждого типа
int coal_res[4] = {INITIAL_RES, INITIAL_RES, INITIAL_RES, INITIAL_RES};
int iron_res[4] = {INITIAL_RES, INITIAL_RES, INITIAL_RES, INITIAL_RES};
int copper_res[4] = {INITIAL_RES, INITIAL_RES, INITIAL_RES, INITIAL_RES};

// Глобальные счётчики
int iron_ingots = 0;
int copper_ingots = 0;
int iron_gears = 0;
int copper_gears = 0;

int coal_sent = 0;
int iron_sent = 0;
int copper_sent = 0;

int coal_processed = 0;
int iron_processed = 0;
int copper_processed = 0;

// === Области добычи ===
proctype Coal_area(byte area_id) {
    do
    :: atomic { 
        if
        :: coal_res[area_id] > 0 ->
            cCoalOre_to_drills[area_id] ! COAL_ORE_ID;
            printf("Coal_area[%d]: sent coal, 1 remaining = %d\n", area_id, coal_res[area_id]);
            coal_res[area_id]--;
            printf("Coal_area[%d]: sent coal, 2 remaining = %d\n", area_id, coal_res[area_id]);
            coal_sent++;
            printf("Coal_sent = %d\n", coal_sent);
        :: else -> break;
        fi 
        }
    od
}

proctype Iron_area(byte area_id) {
    do
    :: atomic { if
        :: iron_res[area_id] > 0 ->
            cIronOre_to_drills[area_id] ! IRON_ORE_ID;
            printf("Iron_area[%d]: sent iron, 1 remaining = %d\n", area_id, iron_res[area_id]);
            iron_res[area_id]--;
            printf("Iron_area[%d]: sent iron, 2 remaining = %d\n", area_id, iron_res[area_id]);
            iron_sent++;
            printf("Iron_sent = %d\n", iron_sent);
        :: else -> break;
        fi 
        }
    od
}

proctype Copper_area(byte area_id) {
    do
    :: atomic { 
        if
        :: copper_res[area_id] > 0 ->
            cCopperOre_to_drills[area_id] ! COPPER_ORE_ID;
            printf("Copper_area[%d]: sent copper, 1 remaining = %d\n", area_id, copper_res[area_id]);
            copper_res[area_id]--;
            printf("Copper_area[%d]: sent copper, 2 remaining = %d\n", area_id, copper_res[area_id]);
            copper_sent++;
            printf("Copper_sent = %d\n", copper_sent);
        :: else -> break;
        fi 
        }
    od
}

// === Буры ===
proctype Burner_mining_drill(byte area_type; byte drill_id) {
    byte msg;
    do
    :: atomic { 
        if
        :: area_type == 0 -> 
            if 
            :: cCoalOre_to_drills[drill_id % 4] ? [msg] ->
                cCoalOre_to_drills[drill_id % 4] ? msg;
                printf("Drill[%d]: received ore type %d from area %d\n", drill_id, msg, drill_id % 4);
                cDrills_to_furnace_coal ! msg;
            :: else -> break;
            fi
        :: area_type == 1 -> 
            if
            :: cIronOre_to_drills[drill_id % 4] ? [msg] ->
                cIronOre_to_drills[drill_id % 4] ? msg;
                printf("Drill[%d]: received ore type %d from area %d\n", drill_id, msg, drill_id % 4);
                cDrills_to_furnace_iron ! msg;
            :: else -> break;
            fi
        :: area_type == 2 -> 
            if
            :: cCopperOre_to_drills[drill_id % 4] ? [msg] ->
                cCopperOre_to_drills[drill_id % 4] ? msg;
                printf("Drill[%d]: received ore type %d from area %d\n", drill_id, msg, drill_id % 4);
                cDrills_to_furnace_copper ! msg;
            :: else -> break;
            fi
        fi
    }
    od
}

// === Печи ===
proctype Furnace(byte furnace_type) {
    byte msg1, msg2, msg3;
    do
    :: atomic {
        if
        :: furnace_type == 0 ->
            if
            :: cDrills_to_furnace_coal ? [msg1] && cDrills_to_furnace_iron ? [msg2] && cDrills_to_furnace_iron ? [msg3] ->
                cDrills_to_furnace_coal ? msg1;
                cDrills_to_furnace_iron ? msg2;
                cDrills_to_furnace_iron ? msg3;
                cFurnace_to_ingots_iron ! IRON_INGOT_ID;
                atomic {
                    iron_processed = iron_processed + 2;
                    coal_processed = coal_processed + 1;
                }
                iron_ingots++;
                printf("Furnace: produced 1 iron ingot (total: %d)\n", iron_ingots);
            :: else -> break;
            fi
        :: furnace_type == 1 ->
            if
            :: cDrills_to_furnace_coal ? [msg1] && cDrills_to_furnace_copper ? [msg2] && cDrills_to_furnace_copper ? [msg3] ->
                cDrills_to_furnace_coal ? msg1;
                cDrills_to_furnace_copper ? msg2;
                cDrills_to_furnace_copper ? msg3;
                cFurnace_to_ingots_copper ! COPPER_INGOT_ID;
                atomic {
                    copper_processed = copper_processed + 2;
                    coal_processed = coal_processed + 1;
                }
                copper_ingots++;
                printf("Furnace: produced 1 copper ingot (total: %d)\n", copper_ingots);
            :: else -> break;
            fi
        fi
    }
    od
}

// === Коллекторы (производство шестерён) ===
proctype Collector(byte collector_type) {
    byte msg1, msg2;
    do
    :: atomic { 
        if
        :: collector_type == 0 -> // Железная шестерня: 1 слиток → 1 шестерня
            if
            :: cFurnace_to_ingots_iron ? [msg1] ->
                printf("Collector[%d]: iron_ingots = %d, iron_gears = %d\n", collector_type, iron_ingots, iron_gears);
                cFurnace_to_ingots_iron ? msg1 ->
                cIngots_to_gear_iron ! IRON_GEAR_ID;
                atomic {
                    iron_gears = iron_gears + 1;
                }
                printf("Collector: produced 1 iron gear (total: %d)\n", iron_gears);
            :: else -> break;
            fi
        :: collector_type == 1 -> // Медная шестерня: 2 слитка → 1 шестерня
            atomic {
                if
                :: len(cFurnace_to_ingots_copper) >= 2 ->
                        //cFurnace_to_ingots_copper ? [msg1] && cFurnace_to_ingots_copper ? [msg2] ->
                        printf("Collector[%d]: copper_ingots = %d, copper_gears = %d\n", collector_type, copper_ingots, copper_gears);
                        cFurnace_to_ingots_copper ? msg1 ->
                        cFurnace_to_ingots_copper ? msg2 ->
                        cIngots_to_gear_copper ! COPPER_GEAR_ID;
                        atomic {
                            copper_gears = copper_gears + 1;
                        }
                        printf("Collector: produced 1 copper gear (total: %d)\n", copper_gears);
                :: else -> break;
                fi
            }
        fi
    }
    od
}

// === Инициализация ===
init {
    byte i;

    
    // Запуск областей
    for (i : 0 .. 3) {
        run Coal_area(i);
        run Iron_area(i);
        run Copper_area(i);
    }

    // 12 буров: 4 угля, 4 железа, 4 меди
    for (i : 0 .. 11) {
        if
        :: i < 4  -> run Burner_mining_drill(0, i); // уголь
        :: i < 8  -> run Burner_mining_drill(1, i); // железо
        :: else   -> run Burner_mining_drill(2, i); // медь
        fi
    }

    // 8 печей: 4 железа, 4 меди
    for (i : 0 .. 7) {
        if
        :: i < 4 -> run Furnace(0);
        :: else  -> run Furnace(1);
        fi
    }

    // 8 коллекторов: 4 железа, 4 меди
    for (i : 0 .. 7) {
        if
        :: i < 4 -> run Collector(0);
        :: else  -> run Collector(1);
        fi
    }

    printf("iron_ingots %d\n", iron_ingots);
    printf("copper_ingots %d\n", copper_ingots);
    printf("iron_gears %d\n", iron_gears);
    printf("copper_gears %d\n", copper_gears);

    printf("Final: iron_ingots=%d, copper_ingots=%d, iron_gears=%d, copper_gears=%d\n",
       iron_ingots, copper_ingots, iron_gears, copper_gears);

    printf("Resources sent: coal=%d, iron=%d, copper=%d\n", coal_sent, iron_sent, copper_sent);
    printf("Resources processed: coal=%d, iron=%d, copper=%d\n", coal_processed, iron_processed, copper_processed);
}
