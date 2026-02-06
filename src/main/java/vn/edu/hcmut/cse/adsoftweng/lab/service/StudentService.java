package vn.edu.hcmut.cse.adsoftweng.lab.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vn.edu.hcmut.cse.adsoftweng.lab.entity.Student;
import vn.edu.hcmut.cse.adsoftweng.lab.repository.StudentRepository;

import java.util.List;
import java.util.UUID;

@Service
public class StudentService {

	@Autowired
	private StudentRepository repository;

	public List<Student> getAll() {
		return repository.findAll();
	}

	public Student getById(String id) {
		return repository.findById(id).orElse(null);
	}

	public List<Student> searchByName(String keyword) {
		if (keyword == null || keyword.trim().isEmpty()) {
			return getAll();
		}
		return repository.findByNameContainingIgnoreCase(keyword);
	}

	public Student create(Student student) {
		if (student.getId() == null || student.getId().isEmpty()) {
			student.setId(UUID.randomUUID().toString());
		}
		return repository.save(student);
	}

	public Student update(String id, Student student) {
		Student existing = getById(id);
		if (existing != null) {
			existing.setName(student.getName());
			existing.setEmail(student.getEmail());
			existing.setAge(student.getAge());
			return repository.save(existing);
		}
		return null;
	}

	public void delete(String id) {
		repository.deleteById(id);
	}
}
