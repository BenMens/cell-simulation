class ActionView extends ViewBase {
    ArrayList<ActionViewClient> clients = new ArrayList<ActionViewClient>();
    ActionBaseModel actionModel;


    ActionView(ActionBaseModel actionModel) {
        this.actionModel = actionModel;
    }


    void registerClient(ActionViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ActionViewClient client) {
        clients.remove(client);
    }

    void beforeDrawChildren() {
        stroke(200, 0, 0);
        strokeWeight(40);
        point(50, 50);
    }
}
