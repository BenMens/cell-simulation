class ButtonView extends ViewBase {

    PImage buttonImage;

    ButtonView(ViewBase parentView) {
        super(parentView);        
    }


    void beforeDrawChildren() {
        if (buttonImage != null) {
            Rectangle2D.Float boundsRect = getBoundsRect();

            image(buttonImage, 
                boundsRect.x, 
                boundsRect.y, 
                boundsRect.width, 
                boundsRect.height);
        }
    }


    boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
        for (ButtonViewClient client: getClientsImplementing(ButtonViewClient.class)) {
            client.onClick(this);
        }

        return true;
    }

}
