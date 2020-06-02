class SelectOptionView extends ViewBase {

    boolean isSelected = false;

    SelectOptionView(ViewBase parentView) {
        super(parentView);

        this.shouldClip = true;
    }


    void registerClient(SelectOptionViewClient client) {
        registerSubscriber(client);
    }

    void unregisterClient(SelectOptionViewClient client) {
        unregisterSubscriber(client);
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
