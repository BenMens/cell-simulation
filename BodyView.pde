class BodyView extends ViewBase {
    ArrayList<BodyViewClient> clients = new ArrayList<BodyViewClient>();
    BodyModel bodyModel;


    BodyView(BodyModel bodyModel) {
        this.bodyModel = bodyModel;
    }


    void registerClient(BodyViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(BodyViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        // if(bodyModel.keysPressed['g'] == true) {

        // }
    }
}
