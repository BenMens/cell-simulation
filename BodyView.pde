class BodyView extends ViewBase {
    ArrayList<BodyViewClient> clients = new ArrayList<BodyViewClient>();
    BodyModel bodyModel;

    ViewBase cellLayerView;
    ViewBase particleLayerView;
    

    BodyView(ViewBase parentView, BodyModel bodyModel) {
        super(parentView);

        this.bodyModel = bodyModel;

        cellLayerView = new ViewBase(this);

        particleLayerView = new ViewBase(this);
        
        setFrameRect(
          0, 0,
          bodyModel.gridSize.x * 100 + 20,
          bodyModel.gridSize.y * 100 + 20
        );

        setBoundsRect(
          -10, -10,
          getFrameRect().width,
          getFrameRect().height
        );
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

        if (keysPressed['g'] == true) {
            strokeWeight(4);
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
