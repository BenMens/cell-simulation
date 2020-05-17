class ActionBaseModel {
    ArrayList<ActionModelClient> clients = new ArrayList<ActionModelClient>();
    ActionModelParent parentModel;


    ActionBaseModel(ActionModelParent parentModel) {
        this.parentModel = parentModel;
        parentModel.addAction(this);
    }
    

    void registerClient(ActionModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ActionModelClient client) {
        clients.remove(client);
    }


    void tick() {
    }
}
