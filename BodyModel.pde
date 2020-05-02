class BodyModel {
    ArrayList<BodyModelClient> clients = new ArrayList<BodyModelClient>();

    ArrayList<CellModel> cellModels = new ArrayList<CellModel>();

    PVector gridSize;


    BodyModel(PVector gridSize) {
        this.gridSize = gridSize;

        addCell(new CellModel(new PVector(0, 0)));
    }


    void registerClient(BodyModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);

            for(CellModel cellModel: cellModels) {
                client.onAddCell(this, cellModel);
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
}
