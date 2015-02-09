import java.util.ArrayList;

public class mcm {
	private long vTotal = 10;
	private long n1 = 100;
	private long i1 = 5;
	private long n2 = 100;
	private long i2 = 10;
	private double deathRate = 0.3;
	private double spreadRate = 5;
	private long total = n1+ n2;
	private long max = 0;
	private ArrayList<Integer> visited = new ArrayList<Integer>();
	
	public void run1(){
		if (i1==0){
			return;
		}
		long death = Math.round(i1*deathRate);
		i1 = Math.max(i1 - death + Math.round(spreadRate * (i1 * (n1 - i1) / n1)) - vTotal, 0);
		n1 = n1 - death;
		run1 ();
	}
	
	public void run2(){
		if (i2==0){
			return;
		}
		long death = Math.round(i2*deathRate);
		i2 = Math.max(i2 - death + Math.round(spreadRate * (i2 * (n2 - i2) / n2)) - vTotal, 0);
		n2 = n2 - death;
		run2 ();
	}

	public void run(int a) {
		if (i1 ==0){
			run2();
			return;
		}
		if (i2 ==0){
			run1();
			return;
		}
		long death1 = Math.round(i1 * deathRate);
		long death2 = Math.round(i2 * deathRate);
		i1 = Math.max(i1 - death1 + Math.round(spreadRate * (i1 * (n1 - i1) / n1))- a, 0);
		i2 = Math.max(i2 - death2 + Math.round(spreadRate * (i2 * (n2 - i2) / n2))- vTotal + a, 0);
		n1 = n1 - death1;
		n2 = n2 - death2;
	}
	
	public  void reset(){
		n1 = 100;
		i1 = 30;
		n2 = 50;
		i1 = 5;
	}
	
	public void test(){
		if (i1 ==0 && i2 ==0){
			
			if (max <=n1 + n2){
				max = n1 + n2;
				System.out.println(visited +" " +  n1 + " " +n2 + " " + (n1+ n2));

			}
			return;
		}
		long[] previous = new long[] {n1, i1, n2, i2};
		
		for (int i =0; i <=vTotal; i ++){
			visited.add(i);
			run(i);
			test();
			visited.remove(visited.size()- 1);
			n1 = previous[0];
			i1 = previous[1];
			n2 = previous[2];
			i2 = previous[3];
		}
	}

	public static void main(String[] args) {
		mcm m = new mcm();
		m.test();
		System.out.println(m.max + " " +m.total);
		
	}
}
