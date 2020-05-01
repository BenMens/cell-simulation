class BodyView {
    BodyViewClient clientController;

    BodyView() {
    }

    void setController(BodyViewClient clientController) {
        this.clientController = clientController;
    }

    void draw() {
        noStroke();
        fill(0);
        textSize(30);
        textAlign(LEFT, TOP);
        
        text("De body heet: " + clientController.getBodyModel().name, 0, 0);
    }
}
