class ButtonView extends ViewBase {

    PImage buttonImage;

    ButtonView(ViewBase parentView) {
        super(parentView);        
    }


    void registerClient(ButtonViewClient client) {
        registerSubscriber(client);
    }


    void unregisterClient(ButtonViewClient client) {
        unregisterSubscriber(client);
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
        for (ButtonViewClient client: getSubscribersImplementing(ButtonViewClient.class)) {
            client.onClick(this);
        }

        return true;
    }

}
