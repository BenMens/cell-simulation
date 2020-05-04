class CellView extends ViewBase {
    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;

    boolean selected = false;


    CellView(CellModel cellModel) {
        this.cellModel = cellModel;
    }


    void registerClient(CellViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CellViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        noStroke();

        fill(250, 90, 70);
        rect(0, 0, 100, 100);

        fill((selected) ? color(0, 0, 200) : color(255, 165, 135));
        rect(10, 10, 80, 80);
        
        fill(0, 0, 0);
        text(String.valueOf(cellModel.wallHealth) , 10, 50);
    }


    boolean afterMousePressedChildren() {
        
        PVector viewPos = screenPosToViewPos(new PVector(mouseX, mouseY));

        if (viewPos.x > 0 && viewPos.x < 100 && viewPos.y > 0 && viewPos.y < 100) {
            selected = !selected;
            return true;
        } else {
            selected = false;
          return false;
        }    
    }
}
