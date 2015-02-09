import java.util.ArrayList;
import java.util.Collections;


public class model {
	public int[][] state;
	public int size;
	public double sickToDead = .2;
	public double infectByDead = 0;
	public double infectBySick = .1;
	public int healthy=0;
	public int vaccine = 1;
	public int dead = 2;
	public int sick =3;
	public int deadCount;
	public ArrayList<int[]> newSick;
	public ArrayList<int[]> newDead;
	public ArrayList<int[]> sickppl;
	public int time;
	public int vaccineTime = 5;
	
	public model(int n){
		newSick = new ArrayList<>();
		newDead = new ArrayList<>();
		state = new int[n][n];
		size = n;
		deadCount =0;
		time = 0;
	}
	
	public void updateSick(int i, int j){
		if (Math.random() < sickToDead){
			newDead.add(new int[] {i, j});
		}
	}
	
	
	public boolean checkBounds(int i, int j){
		return (i >=0 && i < size && j >=0 && j < size);
	}
	
	public void updateHealthy(int i, int j){
		int nextTo = 0;
		if (checkBounds(i+1, j) && (state[i+1][j] == sick || state[i+1][j] == dead)){
			nextTo = Math.max(nextTo, state[i+1][j]);
		}
		if (checkBounds(i-1, j) && (state[i-1][j] == sick || state[i-1][j] == dead)){
			nextTo = Math.max(nextTo, state[i-1][j]);
		}
		if (checkBounds(i, j-1) && (state[i][j-1] == sick || state[i][j-1] == dead)){
			nextTo = Math.max(nextTo, state[i][j-1]);
		}
		if (checkBounds(i, j+1) && (state[i][j+1] == sick || state[i][j+1] == dead)){
			nextTo = Math.max(nextTo, state[i][j+1]);
		}
		if (nextTo == dead && Math.random() < infectByDead){
			newSick.add(new int[]{i, j});
		}
		if (nextTo == sick && Math.random() < infectBySick){
			newSick.add(new int[]{i, j});
		}
	}
	
	public boolean updateNextGen(int medicine){
		time ++;
		boolean hasSick = false;
		sickppl = new ArrayList<>();
		for (int i =0; i <size; i ++){
			for (int j =0; j < size; j ++){
				if (state[i][j]==sick){
					updateSick(i, j);
					sickppl.add(new int[]{i, j});
					hasSick = true;
				}
				else if (state[i][j] == healthy){
					updateHealthy(i, j);
				}
			}
		}
		for (int[] a : newSick){
			state[a[0]][a[1]] = sick;
		}

		
		Collections.shuffle(newSick);
		Collections.shuffle(sickppl);
		newSick.addAll(sickppl);
		for (int i =0; i < Math.min(newSick.size(), medicine); i ++){
			int[] a = newSick.get(i);
			state[a[0]][a[1]] = vaccine;
		}
		for (int[] a : newDead){
			state[a[0]][a[1]] = dead;
		}
		deadCount += newDead.size();

		newSick.clear();
		newDead.clear();
		return hasSick;
	}
	
	public void makeSick(int i, int j){
		state[i][j] = sick;
	}
	
	public void vaccinate(int i, int j){
		state[i][j] = vaccine;
	}
	
	public void loop(int m){
		for (int i =0; i <m; i ++){
			updateNextGen(0);
		}
		for (int i=0; i < size; i ++){
			System.out.print("[");
			for (int j =0; j < size; j++){
				System.out.print(state[i][j]);
			}
			System.out.println("]");
			
		}
		System.out.println(deadCount);
	}
	
	public void runToFinish(){
		while(updateNextGen(0)){
			
		}
	}
	
	public static void main(String[] args){
		model m = new model(5);
		m.makeSick(2,3);
		m.runToFinish();
		System.out.println(m.deadCount +" " + m.time);
	}
}
