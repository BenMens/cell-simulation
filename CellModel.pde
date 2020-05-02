class CellModel {
    ArrayList<CellModelClient> clients = new ArrayList<CellModelClient>();
    PVector position;


    CellModel(PVector position) {
        this.position = position;
    }


    void registerClient(CellModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CellModelClient client) {
        clients.remove(client);
    }
}
