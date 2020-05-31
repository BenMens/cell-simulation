class SelectOptionView extends ViewBase {
    ArrayList<SelectOptionViewClient> clients = new ArrayList<SelectOptionViewClient>();

    boolean isSelected = false;

    SelectOptionView(ViewBase parentView) {
        super(parentView);

        this.shouldClip = true;
    }


    void registerClient(SelectOptionViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }  
    }

    void unregisterClient(SelectOptionViewClient client) {
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
            background(10, 10, 50);
        } else {
            background(10, 50, 10);
        }

        text("Action", 5, 30);
    }

}
