

import java.awt.Point;
import java.util.ArrayList;
import java.util.Collections;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import javafx.util.Duration;


public class Cellmodel extends Application {
	private Color sickColor = Color.GREEN;
	private Color vaccineColor = Color.BLUE;
	private Color deadColor = Color.BLACK;
	private int gridSize =100;
	private Rectangle[][] rect = new Rectangle[gridSize][gridSize];
	private Color[][] nextStates = new Color[gridSize][gridSize];
	private GridPane grid = new GridPane();
	private int deadCount = 0;
	private ArrayList<Rectangle> weaken = new ArrayList<Rectangle>();
	private ArrayList<Rectangle> newSick = new ArrayList<Rectangle>();
	private ArrayList<Rectangle> newDead = new ArrayList<Rectangle>();
	private ArrayList<Circle> drugs = new ArrayList<Circle>();
	private int drugX = 0;
	private int drugY = 0;
	private Group root = new Group();
	public model m;
	
	@Override
	public void start(Stage s) throws Exception {
		m = new model(gridSize);
		
		for (int i = 0; i < gridSize; i ++){
			for (int j=0; j < gridSize; j ++){
				Rectangle r = new Rectangle(6, 6, Color.WHITE);
				rect[i][j] = r;
				int x = i;
				int y = j;
				r.setOnMouseClicked(e -> {m.makeSick(x, y); r.setFill(sickColor);});
				r.setStroke(Color.BLACK);
				grid.add(r, j, i);
			}
		}
		VBox v = new VBox();
		
		HBox h = new HBox();
		Button button = new Button("Medicine");
		TextField text = new TextField();
		button.setOnAction(e -> updateNextGen(Integer.parseInt(text.getText())));
		h.getChildren().addAll(text, button);
		
		HBox h2 = new HBox();
		Button button2 = new Button("Run");
		TextField text2 = new TextField();
		button2.setOnAction(e -> loop(Integer.parseInt(text2.getText())));
		h.getChildren().addAll(button2, text2);
		
		v.getChildren().addAll(h, h2);
		
		v.setTranslateX(300);
		root.getChildren().addAll(grid, v);
		s.setScene(new Scene(root));
		s.show();
	}
	
	public void loop(int loops){
		for (int i =0; i < loops; i ++){
			updateNextGen(0);
		}
	}
	
	public void updateNextGen(int medicine){
		int healthy=0;
		int vaccine = 1;
		int dead = 2;
		int sick =3;
		
		int susceptibleCount =0;
		int vaccineCount =0;
		int deadCount =0;
		int sickCount = 0;
		m.updateNextGen(medicine);
		for (int i =0; i < gridSize; i++){
			for (int j =0; j < gridSize; j++){
				if (m.state[i][j] == healthy){
					rect[i][j].setFill(Color.WHITE);
					susceptibleCount ++;
				}
				if (m.state[i][j] == vaccine){
					rect[i][j].setFill(vaccineColor);
					vaccineCount++;
				}
				if (m.state[i][j] == dead){
					rect[i][j].setFill(deadColor);
					deadCount ++;
				}
				if (m.state[i][j] == sick){
					rect[i][j].setFill(sickColor);
					sickCount++;
				}
			}
		}
		System.out.println("Susceptible: " + susceptibleCount);
		System.out.println("Vaccine: " + vaccineCount);
		System.out.println("Infected: " + sickCount);
		System.out.println("Advanced: " + deadCount);
	}

	
	public static void main(String[] args){
		launch(args);
		Cellmodel c = new Cellmodel();
		
	}

}
