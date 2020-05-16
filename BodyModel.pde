class BodyModel {
    ArrayList<BodyModelClient> clients = new ArrayList<BodyModelClient>();

    ArrayList<CellModel> cellModels = new ArrayList<CellModel>();
    private CellModel selectedCell = null;

    ArrayList<ParticleBaseModel> particleModels = new ArrayList<ParticleBaseModel>();

    PVector gridSize;


    BodyModel(PVector gridSize) {
        this.gridSize = gridSize;
    }


    void registerClient(BodyModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);

            for(CellModel cellModel: cellModels) {
                client.onAddCell(this, cellModel);
            }

            for(ParticleBaseModel particleModel: particleModels) {
                client.onAddParticle(this, particleModel);
            }
        }
    }

    void unregisterClient(BodyModelClient client) {
        clients.remove(client);
    }


    void addCell(CellModel cellModel) {
        cellModels.add(cellModel);

        for(BodyModelClient client: clients) {
            client.onAddCell(this, cellModel);
        }
    }


    void addParticle(ParticleBaseModel particleModel) {

        particleModels.add(particleModel);

        for(BodyModelClient client: clients) {
            client.onAddParticle(this, particleModel);
        }        
    }


    CellModel getSelectedCell() {
        return selectedCell;
    }

    void selectCell(CellModel cell) {
        selectedCell = cell;
    }

    void unSelectCell(CellModel cell) {
        if (cell == selectedCell) {
            selectedCell = null;
        }
    }


    CellModel findCellAtPosition(int x, int y) {
        for (CellModel cellModel: cellModels) {
            if (cellModel.position.x == x && cellModel.position.y == y) {
                return cellModel;
            }
        }

        return null;
    }


    void tick() {
        for (ParticleBaseModel particle: particleModels) {
            particle.tick();
        }

        for (CellModel cell: cellModels) {
            cell.tick();
        }
    }
}
