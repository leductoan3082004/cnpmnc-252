package vn.edu.hcmut.cse.adsoftweng.lab.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vn.edu.hcmut.cse.adsoftweng.lab.entity.Student;

import java.util.List;

public interface StudentRepository extends JpaRepository<Student, String> {
	List<Student> findByNameContainingIgnoreCase(String name);
}
