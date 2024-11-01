from itertools import combinations

class MinitermGenerator:
    def __init__(self, predicates):
        self.predicates = predicates

    def generate_miniterms(self):
        miniterms = []
        n = len(self.predicates)
        
        # Generate combinations by size (1, 2, ..., n predicates)
        for size in range(1, n + 1):
            for combo in combinations(self.predicates, size):
                miniterm = []
                
                # Iterate through all true/false configurations for this combination
                for i in range(2 ** size):
                    terms = []
                    for j in range(size):
                        if (i >> j) & 1:
                            terms.append(combo[j])
                        else:
                            terms.append(f"NOT {combo[j]}")
                    miniterms.append(" AND ".join(terms))
        
        return miniterms

# Example usage
predicates = ["A > 5", "B < 10", "C = 'X'"]
generator = MinitermGenerator(predicates)
fragments = generator.generate_miniterms()
for fragment in fragments:
    print(fragment)
