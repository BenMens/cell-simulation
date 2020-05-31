class BodyModel {
    ArrayList<BodyModelClient> clients = new ArrayList<BodyModelClient>();

    ArrayList<CellModel> cellModels = new ArrayList<CellModel>();
    private CellModel selectedCell = null;

    ArrayList<ParticleBaseModel> particleModels = new ArrayList<ParticleBaseModel>();

    PVector gridSize;


    BodyModel(PVector gridSize) {
        this.gridSize = gridSize;

        for (int i = 0; i < 25; i++) {
            particleFactory.createParticle("food", this);
        }   

        for (int i = 0; i < 25; i++) {
            particleFactory.createParticle("waste", this);
        }

        for (int i = 0; i < 25; i++) {
            particleFactory.createParticle("oxygene", this);
        }

        for (int i = 0; i < 25; i++) {
            particleFactory.createParticle("co2", this);
        }
    }


    void registerClient(BodyModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);

            for(CellModel cellModel: cellModels) {
                client.onAddCell(cellModel);
            }

            for(ParticleBaseModel particleModel: particleModels) {
                client.onAddParticle(particleModel);
            }
        }
    }

    void unregisterClient(BodyModelClient client) {
        clients.remove(client);
    }


    void addCell(CellModel cellModel) {
        cellModels.add(cellModel);

        for(BodyModelClient client: new ArrayList<BodyModelClient>(clients)) {
            client.onAddCell(cellModel);
        }
    }

    void removeCell(CellModel cellModel) {
        cellModels.remove(cellModel);

        if (selectedCell == cellModel) {
            unSelectCell(selectedCell);
        }
    }


    void addParticle(ParticleBaseModel particleModel) {

        particleModels.add(particleModel);

        for(BodyModelClient client: new ArrayList<BodyModelClient>(clients)) {
            client.onAddParticle(particleModel);
        }
    }

    void removeParticle(ParticleBaseModel particleModel) {
        particleModels.remove(particleModel);
    }


    CellModel getSelectedCell() {
        return selectedCell;
    }


    void selectCell(CellModel cell) {
        selectedCell = cell;

        for(BodyModelClient client: new ArrayList<BodyModelClient>(clients)) {
            client.onSelectCell(selectedCell);
        }
    }


    void unSelectCell(CellModel cell) {
        if (cell == selectedCell) {
            selectedCell = null;

        for(BodyModelClient client: new ArrayList<BodyModelClient>(clients)) {
                client.onSelectCell(selectedCell);
            }        
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

        for (int i = particleModels.size() - 1; i >= 0; i--) {
            particleModels.get(i).cleanUpTick();
        }

        for (int i = cellModels.size() - 1; i >= 0; i--) {
            cellModels.get(i).cleanUpTick();
        }
    }
}
