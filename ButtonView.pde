class ButtonView extends ViewBase {

    ArrayList<ButtonViewClient> clients = new ArrayList<ButtonViewClient>();

    PImage buttonImage;

    ButtonView(ViewBase parentView) {
        super(parentView);        
    }


    void registerClient(ButtonViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ButtonViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        Rectangle2D.Float boundsRect = getBoundsRect();

        if (buttonImage != null) {
            image(buttonImage, 
                0, 
                0, 
                boundsRect.width, 
                boundsRect.height);
        }
    }

    boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
        for (ButtonViewClient client: clients) {
            client.onClick(this);
        }

        return true;
    }

}
