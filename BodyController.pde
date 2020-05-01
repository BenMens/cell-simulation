interface BodyViewClient {
    BodyModel getBodyModel();
}


class BodyController implements BodyViewClient {
    BodyModel bodyModel;
    BodyView bodyView;

    BodyController(BodyModel bodyModel, BodyView bodyView) {
        this.bodyModel = bodyModel;
        this.bodyView = bodyView;

        this.bodyView.setController(this);
    }

    BodyModel getBodyModel() {
        return this.bodyModel;
    }

}