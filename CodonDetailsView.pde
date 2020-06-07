class CodonDetailsView extends ViewBase {
    CodonBaseModel codonModel;

    boolean isSelected = false;

    CodonDetailsView(ViewBase parentView, CodonBaseModel codonModel) {
        super(parentView);

        this.codonModel = codonModel;

        this.shouldClip = true;
    }


    boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
        if (mousePressed) {
            this.isSelected = !this.isSelected;
            
            return true;
        }
        
        return false;
    }


    void beforeDrawChildren() {
        Rectangle2D.Float boundsRect = getBoundsRect();

        // if (isSelected) {
        //     fill(255);
        //     background(10, 10, 100);
        // } else {
        //     fill(255);
        //     background(10, 100, 10);
        // }


        background(0);

        float xOffset = codonModel.degradation * boundsRect.width / 2;

        fill(codonModel.getMainColor());
        rect(xOffset, 0, boundsRect.width / 2 - xOffset, boundsRect.height);

        fill(codonModel.getSecondaryColor());
        rect(boundsRect.width / 2, 0, boundsRect.width / 2 - xOffset, boundsRect.height);

        textAlign(CENTER, CENTER);

        fill(255);

        text(codonModel.getDisplayName(), boundsRect.width / 4, boundsRect.height / 2);

        text(codonModel.codonParameter, boundsRect.width * 3 / 4, boundsRect.height / 2);
    }

    void onFrameRectChange(Rectangle2D.Float oldRect) {
        setBoundsRect(0, 0, this.getFrameRect().width, this.getFrameRect().height);
    }


}
