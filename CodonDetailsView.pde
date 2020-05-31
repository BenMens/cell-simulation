class CodonDetailsView extends ViewBase {
    ArrayList<CodonDetailsViewClient> clients = new ArrayList<CodonDetailsViewClient>();

    boolean isSelected = false;

    CodonDetailsView(ViewBase parentView) {
        super(parentView);

        this.shouldClip = true;
    }


    void registerClient(CodonDetailsViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }  
    }

    void unregisterClient(CodonDetailsViewClient client) {
        clients.remove(client);
    }

    boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
        if (mousePressed) {
            this.isSelected = !this.isSelected;
            
            return true;
        }
        
        return false;
    }


    void beforeDrawChildren() {
        if (isSelected) {
            fill(255);
            background(10, 10, 100);
        } else {
            fill(255);
            background(10, 100, 10);
        }

        text("Action", 5, 30);
    }

}
