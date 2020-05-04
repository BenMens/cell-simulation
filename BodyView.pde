class BodyView extends ViewBase {
    ArrayList<BodyViewClient> clients = new ArrayList<BodyViewClient>();
    BodyModel bodyModel;

    ViewBase cellLayerView;
    ViewBase particleLayerView;
    

    BodyView(BodyModel bodyModel) {
        this.bodyModel = bodyModel;

        cellLayerView = new ViewBase();
        this.addChildView(cellLayerView);

        particleLayerView = new ViewBase();
        this.addChildView(particleLayerView);
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
        PVector gridSize = bodyModel.gridSize;

        strokeWeight(10);
        stroke(0);
        noFill();
        rect(-5, -5, gridSize.x * 100 + 10, gridSize.y * 100 + 10);

        if(keysPressed['g'] == true) {
            strokeWeight(5);
            stroke(100);
            noFill();

            for(int x = 0; x < gridSize.x; x++) {
                for(int y = 0; y < gridSize.y; y++) {
                    rect(x * 100, y * 100, 100, 100);
                }
            }
        }
    }
}
